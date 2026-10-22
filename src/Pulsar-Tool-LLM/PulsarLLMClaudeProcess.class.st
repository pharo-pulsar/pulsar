"
I own one long-lived Claude Code CLI process and implement the streaming session protocol used by PulsarLLMClaudeAPI.

I spawn the CLI with stream-json input and output, write newline-delimited user messages to its stdin, and translate the NDJSON events it emits into Pulsar agent chunks: text, reasoning, tool lines, tool errors, and errors. I keep the conversation alive across turns because Claude preserves context inside the running process.

I use PulsarLLMUnixProcess for FIFO-backed standard streams and GIOChannel line listeners for stdout and stderr. I serialize turns with a Mutex, handle turn boundaries on result events, and abort a turn with the Claude control-request interrupt message.
"
Class {
	#name : 'PulsarLLMClaudeProcess',
	#superclass : 'Object',
	#instVars : [
		'api',
		'id',
		'title',
		'unixProcess',
		'events',
		'eventsMonitor',
		'turnMutex',
		'writeMutex',
		'startMutex',
		'systemInfo',
		'stderrLines',
		'text',
		'blockKinds',
		'blockTools',
		'toolStates',
		'openToolID',
		'openToolLabel',
		'sawTextDelta',
		'sawThinkingDelta',
		'kinds',
		'turnBlock',
		'started',
		'lastError'
	],
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'instance creation' }
PulsarLLMClaudeProcess class >> api: anAPI id: aString title: aTitle [

	^ self basicNew
		  initializeAPI: anAPI id: aString title: aTitle;
		  yourself
]

{ #category : 'turns' }
PulsarLLMClaudeProcess >> abort [

	started ifFalse: [ ^ self ].
	[
		self writeJSON: (Dictionary
			with: 'type' -> 'control_request'
			with: 'request_id' -> UUID new asString
			with: 'request' -> (Dictionary with: 'subtype' -> 'interrupt')) ]
	on: Error
	do: [ :e | 
		logger error: e.
		self stop ]
]

{ #category : 'events' }
PulsarLLMClaudeProcess >> addEvent: anEvent [

	eventsMonitor critical: [
		events addLast: anEvent.
		eventsMonitor signal ]
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> addStderrLine: aString [

	stderrLines addLast: aString.
	[ stderrLines size > 50 ] 
	whileTrue: [ 
		stderrLines removeFirst ]
]

{ #category : 'accessing' }
PulsarLLMClaudeProcess >> api [

	^ api
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> appendToolJSON: aString for: aToolID [
	| state |
	
	state := toolStates at: aToolID ifAbsent: [ ^ self ].
	state 
		at: 'partial' 
		put: (state at: 'partial' ifAbsent: [ '' ]), aString
]

{ #category : 'tool lines' }
PulsarLLMClaudeProcess >> beginToolLineFor: aToolID [
	| state toolName label |
	
	state := toolStates at: aToolID ifAbsent: [ Dictionary new ].
	toolName := state at: 'name' ifAbsent: [ '?' ].
	label := self toolPendingLabelFor: toolName.
	openToolID := aToolID.
	openToolLabel := label.
	
	self emit: label kind: #tool
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> emit: aChunk kind: aKind [
	
	(aChunk isNil or: [ aChunk isEmpty ]) ifTrue: [ ^ self ].
	
	aKind = #text ifTrue: [ text nextPutAll: aChunk ].
	aKind = #error ifTrue: [ lastError := aChunk ].
	
	(self shouldEmit: aKind) ifFalse: [ ^ self ].
	
	turnBlock ifNotNil: [ :block | 
		block value: aChunk value: aKind ]
]

{ #category : 'lifecycle' }
PulsarLLMClaudeProcess >> ensureStarted [

	started ifTrue: [ ^ self ].
	startMutex critical: [
		started ifTrue: [ ^ self ].
		self startProcess.
		started := true ]
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> errorResult: aString [

	^ Dictionary new
		  at: 'type' 		put: 'result';
		  at: 'is_error' 	put: true;
		  at: 'result' 		put: aString;
		  at: 'errors' 		put: { aString };
		  yourself
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> errorsTextFrom: anEvent [
	| errors |
	
	errors := anEvent at: 'errors' ifAbsent: [ #(  ) ].
	^ String streamContents: [ :stream | 
		errors 
			do: [ :each | stream << each ] 
			separatedBy: [ stream << String lf ] ]
]

{ #category : 'tool lines' }
PulsarLLMClaudeProcess >> finishToolLineFor: aState status: aStatus [
	| toolName input line kind |
	
	toolName := aState at: 'name' ifAbsent: [ '?' ].
	input := aState at: 'input' ifAbsent: [ Dictionary new ].
	line := (self toolIconFor: toolName status: aStatus) , ' ' , (self toolSummaryFor: toolName input: input).
	openToolLabel ifNotNil: [ :label | line := self padString: line to: label size + 2 ].
	openToolID := nil.
	openToolLabel := nil.
	kind := aStatus = 'error'
		ifTrue: [ #toolError ]
		ifFalse: [ #tool ].
		
	self emit: line, String cr kind: kind
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> finishTurn [

	turnBlock := nil.
	openToolID := nil.
	openToolLabel := nil
]

{ #category : 'events' }
PulsarLLMClaudeProcess >> handleAssistant: anEvent [

	| message content |
	message := anEvent at: 'message' ifAbsent: [ ^ self ].
	content := message at: 'content' ifAbsent: [ #(  ) ].
	content do: [ :block |
			| blockType |
			blockType := block at: 'type' ifAbsent: [ nil ].
			blockType = 'thinking' ifTrue: [
				sawThinkingDelta ifFalse: [ self emit: (block at: 'thinking' ifAbsent: [ '' ]) kind: #reasoning ] ].
			blockType = 'tool_use' ifTrue: [
					| toolID state |
					toolID := block at: 'id' ifAbsent: [ nil ].
					state := toolStates at: toolID ifAbsentPut: [ Dictionary new ].
					state
						at: 'name' put: (block at: 'name' ifAbsent: [ '?' ]);
						at: 'input' put: (block at: 'input' ifAbsent: [ Dictionary new ]).
					openToolID ifNil: [ self beginToolLineFor: toolID ] ] ]
]

{ #category : 'events' }
PulsarLLMClaudeProcess >> handleControlRequest: anEvent [
	| request requestID subtype input |
	
	request := anEvent at: 'request' ifAbsent: [ Dictionary new ].
	requestID := anEvent at: 'request_id' ifAbsent: [ nil ].
	subtype := request at: 'subtype' ifAbsent: [ nil ].
	subtype = 'can_use_tool'
		ifTrue: [
			input := request at: 'input' ifAbsent: [ Dictionary new ].
			self 
				sendControlResponse: requestID 
				response: (Dictionary 
					with: 'behavior' -> 'allow' 
					with: 'updatedInput' -> input) ]
		ifFalse: [ 
			self sendControlResponse: requestID response: Dictionary new ]
]

{ #category : 'events' }
PulsarLLMClaudeProcess >> handleEvent: anEvent [
	"Handle one Claude event and answer a result event when the turn ends."
	| type subtype message info status |
	
	anEvent == #terminated ifTrue: [
		self terminateCleanly.
		^ self errorResult: 'Claude process terminated' ].
	anEvent isDictionary ifFalse: [ ^ nil ].
	type := anEvent at: 'type' ifAbsent: [ nil ].
	type = 'system' ifTrue: [
		subtype := anEvent at: 'subtype' ifAbsent: [ nil ].
		subtype = 'init' ifTrue: [ systemInfo := anEvent ].
		subtype = 'api_retry' ifTrue: [ self emit: '⋯ API retry' kind: #reasoning ].
		subtype = 'status' ifTrue: [
			(anEvent at: 'status' ifAbsent: [ nil ]) = 'compacting' ifTrue: [ 
				self emit: '⋯ Compacting context' kind: #reasoning ] ].
			^ nil ].
	type = 'stream_event' ifTrue: [
		self handleStreamEvent: anEvent.
		^ nil ].
	type = 'assistant' ifTrue: [
		self handleAssistant: anEvent.
		^ nil ].
	type = 'user' ifTrue: [
		self handleUser: anEvent.
		^ nil ].
	type = 'result' ifTrue: [ ^ self handleResult: anEvent ].
	type = 'error' ifTrue: [
		message := anEvent at: 'error' ifAbsent: [ Dictionary new ].
		message isDictionary 
			ifTrue: [ message := message at: 'message' ifAbsent: [ message asString ] ].
		self emit: message kind: #error.
		^ nil ].
	type = 'control_request' ifTrue: [
		self handleControlRequest: anEvent.
		^ nil ].
	type = 'control_response' ifTrue: [ ^ nil ].
	type = 'control_cancel_request' ifTrue: [ ^ nil ].
	type = 'rate_limit_event' ifTrue: [
		info := anEvent at: 'rate_limit_info' ifAbsent: [ Dictionary new ].
		status := info at: 'status' ifAbsent: [ nil ].
		status = 'rejected' ifTrue: [ 
			self emit: '⏳ Claude rate limit reached' kind: #error ].
		^ nil ].
	
	^ nil
]

{ #category : 'events' }
PulsarLLMClaudeProcess >> handleResult: anEvent [
	| isError resultText |
	
	isError := anEvent at: 'is_error' ifAbsent: [ false ].
	resultText := anEvent at: 'result' ifAbsent: [ '' ].
	isError = true
		ifTrue: [
			resultText isEmpty ifTrue: [ resultText := self errorsTextFrom: anEvent ].
			resultText isEmpty ifFalse: [ self emit: resultText kind: #error ] ]
		ifFalse: [
			(sawTextDelta not and: [ text contents isEmpty ]) 
				ifTrue: [ 
					resultText isEmpty ifFalse: [ 
						self emit: resultText kind: #text ] ] ].
	
	^ anEvent
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> handleStderrLine: aString [

	self addStderrLine: aString
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> handleStdoutLine: aString [
	| event type subtype |
	
	aString ifEmpty: [ ^ self ].

	event := [ STONJSON fromString: aString ]
		on: Error
		do: [ :e |
			 self addStderrLine: 'Invalid JSON: ', aString.
			 ^ self ].

	event isDictionary ifFalse: [ ^ self ].
	type := event at: 'type' ifAbsent: [ nil ].
	subtype := event at: 'subtype' ifAbsent: [ nil ].
	(type = 'system' and: [ subtype = 'init' ]) ifTrue: [ systemInfo := event ].

	self addEvent: event
]

{ #category : 'events' }
PulsarLLMClaudeProcess >> handleStreamEvent: anEvent [

	| streamEvent streamType index block blockType delta deltaType toolID |
	streamEvent := anEvent at: 'event' ifAbsent: [ ^ self ].
	streamType := streamEvent at: 'type' ifAbsent: [ ^ self ].
	index := streamEvent at: 'index' ifAbsent: [ nil ].
	streamType = 'content_block_start' ifTrue: [
			block := streamEvent at: 'content_block' ifAbsent: [ Dictionary new ].
			blockType := block at: 'type' ifAbsent: [ nil ].
			blockType = 'text' ifTrue: [ blockKinds at: index put: #text ].
			blockType = 'thinking' ifTrue: [ blockKinds at: index put: #reasoning ].
			blockType = 'tool_use' ifTrue: [
					toolID := block at: 'id' ifAbsent: [ nil ].
					blockTools at: index put: toolID.
					blockKinds at: index put: #tool.
					toolStates at: toolID ifAbsentPut: [ Dictionary new ].
					(toolStates at: toolID)
						at: 'name' put: (block at: 'name' ifAbsent: [ '?' ]);
						at: 'input' put: Dictionary new.
					self beginToolLineFor: toolID ] ].
	streamType = 'content_block_delta' ifTrue: [
			delta := streamEvent at: 'delta' ifAbsent: [ Dictionary new ].
			deltaType := delta at: 'type' ifAbsent: [ nil ].
			deltaType = 'text_delta' ifTrue: [
					sawTextDelta := true.
					self emit: (delta at: 'text' ifAbsent: [ '' ]) kind: #text ].
			deltaType = 'thinking_delta' ifTrue: [
					| thinkingText |
					thinkingText := delta at: 'thinking' ifAbsent: [ '' ].
					thinkingText isEmpty ifFalse: [
							sawThinkingDelta := true.
							self emit: thinkingText kind: #reasoning ] ].
			deltaType = 'input_json_delta' ifTrue: [
					toolID := blockTools at: index ifAbsent: [ nil ].
					toolID ifNotNil: [ self appendToolJSON: (delta at: 'partial_json' ifAbsent: [ '' ]) for: toolID ] ] ]
]

{ #category : 'events' }
PulsarLLMClaudeProcess >> handleUser: anEvent [
	| message content |
	
	message := anEvent at: 'message' ifAbsent: [ ^ self ].
	content := message at: 'content' ifAbsent: [ #(  ) ].
	content do: [ :block |
		(block at: 'type' ifAbsent: [ nil ]) = 'tool_result' ifTrue: [
			| toolID state isError |
			toolID := block at: 'tool_use_id' ifAbsent: [ nil ].
			state := toolStates at: toolID ifAbsent: [ nil ].
			state ifNotNil: [
				isError := block at: 'is_error' ifAbsent: [ false ].
				self finishToolLineFor: state status: (isError = true
					 ifTrue: [ 'error' ]
					 ifFalse: [ 'completed' ]) ] ] ]
]

{ #category : 'initialization' }
PulsarLLMClaudeProcess >> initializeAPI: anAPI id: aString title: aTitle [

	api := anAPI.
	id := aString.
	title := aTitle.
	events := OrderedCollection new.
	eventsMonitor := Monitor new.
	stderrLines := OrderedCollection new.
	turnMutex := Mutex new.
	writeMutex := Mutex new.
	startMutex := Mutex new.
	started := false.
	sawThinkingDelta := false.
	text := WriteStream on: String new
]

{ #category : 'testing' }
PulsarLLMClaudeProcess >> isStarted [

	^ started
]

{ #category : 'events' }
PulsarLLMClaudeProcess >> nextEventTimeout: aNumber [
	| event |
	
	eventsMonitor critical: [
		eventsMonitor waitWhile: [ events isEmpty ] maxSeconds: aNumber.
	         event := events
				ifNotEmpty: [ events removeFirst ]
				ifEmpty: [ nil ] ].
	
	^ event
]

{ #category : 'tool lines' }
PulsarLLMClaudeProcess >> padString: aString to: anInteger [

	^ aString size >= anInteger
		  ifTrue: [ aString ]
		  ifFalse: [ aString, (String new: (anInteger - aString size) withAll: Character space) ]
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> prepareTurnWith: aCollection do: aBlock [

	eventsMonitor critical: [ events removeAll ].
	text := WriteStream on: String new.
	blockKinds := Dictionary new.
	blockTools := Dictionary new.
	toolStates := Dictionary new.
	openToolID := nil.
	openToolLabel := nil.
	sawTextDelta := false.
	sawThinkingDelta := false.
	lastError := nil.
	kinds := aCollection ifNil: [ api class defaultStreamKinds ].
	turnBlock := aBlock
]

{ #category : 'turns' }
PulsarLLMClaudeProcess >> runTurn: aString kinds: aCollection do: aBlock [
	"Run one turn and answer a dictionary with the final result event and the accumulated text."

	^ turnMutex critical: [
		| result |
		[
			self ensureStarted.
			self prepareTurnWith: aCollection do: aBlock.
			self writeUserMessage: aString.
			result := nil.
			[ result isNil ] whileTrue: [
				| event |
				event := self nextEventTimeout: self timeout.
				event 
					ifNotNil: [ result := self handleEvent: event ]
					ifNil: [ result := self errorResult: 'Claude stream timed out' ] ].
			self finishTurn.
			Dictionary with: 'event' -> result with: 'text' -> text contents ]
		on: Error
		do: [ :e |
			self finishTurn.
			Dictionary
				with: 'event' -> (self errorResult: e messageText)
				with: 'text' -> (text 
					ifNotNil: [ :stream | stream contents ]
					ifNil: [ '' ]) 
		] 
	]
]

{ #category : 'events' }
PulsarLLMClaudeProcess >> sendControlResponse: aRequestID response: aDictionary [

	aRequestID ifNil: [ ^ self ].
	self writeJSON: (Dictionary
		with: 'type' -> 'control_response'
		with: 'response' -> (Dictionary
			with: 'subtype' -> 'success'
			with: 'request_id' -> aRequestID
			with: 'response' -> aDictionary))
]

{ #category : 'accessing' }
PulsarLLMClaudeProcess >> sessionId [

	^ id
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> shouldEmit: aKind [

	aKind = #error ifTrue: [ ^ true ].
	aKind = #toolError ifTrue: [ ^ kinds includes: #tool ].
	^ kinds includes: aKind
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> startProcess [
	| commandAndArguments |
	
	api ensureConfiguration.
	commandAndArguments := api commandAndArgumentsFor: self.
	unixProcess := PulsarLLMUnixProcess
	   spawn: (commandAndArguments at: 1)
	   arguments: (commandAndArguments at: 2)
	   workingDirectory: api workingDirectory.
	unixProcess onTerminate: [ self addEvent: #terminated ].
	unixProcess startStdoutListener: [ :line | self handleStdoutLine: line ].
	unixProcess startStderrListener: [ :line | self handleStderrLine: line ]
]

{ #category : 'accessing' }
PulsarLLMClaudeProcess >> stderrText [

	^ String streamContents: [ :stream | 
		stderrLines 
			do: [ :each | stream << each ] 
			separatedBy: [ stream << String lf ] ]
]

{ #category : 'lifecycle' }
PulsarLLMClaudeProcess >> stop [

	self terminateCleanly.
	self addEvent: #terminated
]

{ #category : 'accessing' }
PulsarLLMClaudeProcess >> systemInfo [

	^ systemInfo
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> terminateCleanly [

	unixProcess ifNotNil: [ unixProcess stop ].
	unixProcess := nil.
	started := false
]

{ #category : 'accessing' }
PulsarLLMClaudeProcess >> timeout [

	^ api timeout
]

{ #category : 'accessing' }
PulsarLLMClaudeProcess >> title [

	^ title
]

{ #category : 'tool lines' }
PulsarLLMClaudeProcess >> toolIconFor: aToolName status: aStatus [

	^ PulsarLLMOpenCodeAPI toolIcons 
		at: aToolName asLowercase 
		ifAbsent: [
			aStatus = 'error'
				ifTrue: [ '✗' ]
				ifFalse: [ '✓' ] ]
]

{ #category : 'tool lines' }
PulsarLLMClaudeProcess >> toolPendingLabelFor: aToolName [

	^ PulsarLLMOpenCodeAPI toolPendingLabels 
		at: aToolName asLowercase 
		ifAbsent: [ aToolName ]
]

{ #category : 'tool lines' }
PulsarLLMClaudeProcess >> toolSummaryFor: aToolName input: aDictionary [
	| keys key subject |
	
	keys := #( 'file_path' 'filePath' 'path' 'command' 'pattern' 'url' 'query' 'description' 'name' ).
	
	key := keys detect: [ :each | (aDictionary at: each ifAbsent: [ nil ]) isString ] ifNone: [ nil ].
	
	subject := key ifNil: [ aToolName ] ifNotNil: [ :each | aDictionary at: each ].
	
	^ subject truncateTo: 120
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> writeJSON: aDictionary [

	writeMutex critical: [ 
		unixProcess writeLine: (STONJSON toString: aDictionary) ]
]

{ #category : 'private' }
PulsarLLMClaudeProcess >> writeUserMessage: aString [
	| payload |
	
	payload := OrderedDictionary new
		at: 'type' put: 'user';
		at: 'uuid' put: UUID new asString;
		at: 'message'
		put: (Dictionary
			with: 'role' -> 'user'
			with: 'content' -> { (Dictionary with: 'type' -> 'text' with: 'text' -> aString) });
		at: 'session_id' put: id;
		yourself.
		
	self writeJSON: payload
]
