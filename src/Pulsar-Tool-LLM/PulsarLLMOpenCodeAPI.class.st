"
A client for the OpenCode HTTP API, giving Pharo access to a running OpenCode
server (by default on http://127.0.0.1:4096).

It uses ZnClient for transport and STONJSON for payload encoding/decoding.
Methods are grouped by protocol to mirror the API areas: health, sessions,
messages, info, project, instance, files, tools, system, logging, tui,
and events (server-sent events).

The server-side endpoints are documented in the OpenCode project
(see the /doc page served by the server).
"
Class {
	#name : 'PulsarLLMOpenCodeAPI',
	#superclass : 'Object',
	#instVars : [
		'host',
		'port',
		'timeout',
		'model'
	],
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'constants' }
PulsarLLMOpenCodeAPI class >> defaultHost [

	^ '127.0.0.1'
]

{ #category : 'constants' }
PulsarLLMOpenCodeAPI class >> defaultPort [

	^ 4096
]

{ #category : 'constants' }
PulsarLLMOpenCodeAPI class >> defaultStreamKinds [
	"Kinds streamed by default, matching what the OpenCode TUI surfaces."

	^ #( #text #reasoning #tool #step )
]

{ #category : 'examples' }
PulsarLLMOpenCodeAPI class >> exampleEvents [
	    "Consume the OpenCode event stream, print the first few events, and stop."

	    | api eventCount |
	    api := self new.
	    eventCount := 0.
	    [
		    api eventsDo: [ :eachEventName :eachEventData |
				    eachEventData ifNil: [ Error signal: 'event stream ended' ] ifNotNil: [
						    ('event: ' , eachEventName , ' => ' , eachEventData asString) traceCr.
						    eventCount := eventCount + 1.
						    eventCount >= 3 ifTrue: [ Error signal: 'example stop' ] ] ] ]
		    on: Error
		    do: [ :e | ('done after ' , eventCount asString , ' events') traceCr ].
	    ^ eventCount
]

{ #category : 'examples' }
PulsarLLMOpenCodeAPI class >> exampleHealth [
	    "PulsarLLMOpenCodeAPI exampleHealth"

	    | api |
	    api := self new.
	    api isHealthy
		    ifTrue: [ 'OpenCode server is healthy' traceCr ]
		    ifFalse: [ 'OpenCode server is not reachable' traceCr ].
	    ^ api isHealthy
]

{ #category : 'examples' }
PulsarLLMOpenCodeAPI class >> examplePrompt [
	"Create a fresh session, send a prompt, print the reply, and answer it.
	The session is kept so it can be inspected afterwards."
	| api sessionID reply |
	
	api := self new.
	sessionID := (api createSession: 'Pharo example') at: 'id'.
	reply := api answerTextFrom: (api sendText: 'Hello from Pharo! What is 40 + 2?' toSession: sessionID).
	api deleteSession: sessionID.
	
	^ reply
]

{ #category : 'instance creation' }
PulsarLLMOpenCodeAPI class >> onHost: aHost port: aPort [

	| api |
	api := self new.
	api host: aHost.
	api port: aPort.
	^ api
]

{ #category : 'accessing' }
PulsarLLMOpenCodeAPI class >> query: aString [
	"Create a fresh session, send a prompt, print the reply, and answer it.
	The session is kept so it can be inspected afterwards."
	| api sessionID reply |
	
	api := self new.
	sessionID := (api createSession: 'Query') at: 'id'.
	reply := api answerTextFrom: (api sendText: aString toSession: sessionID).
	api deleteSession: sessionID.
	
	^ reply
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> abortSession: aSessionID [

	^ self post: '/session/' , aSessionID , '/abort' json: Dictionary new
]

{ #category : 'system' }
PulsarLLMOpenCodeAPI >> addMCPServer: aName config: aDictionary [

	  ^ self post: '/mcp' json: (Dictionary with: 'name' -> aName with: 'config' -> aDictionary)
]

{ #category : 'info' }
PulsarLLMOpenCodeAPI >> agents [

	^ self get: '/agent'
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> answerTextFrom: aResponse [
	"Extract the concatenated text of all text parts in a message response."

	| parts |
	parts := aResponse at: 'parts' ifAbsent: [ ^ '' ].
	^ String streamContents: [ :stream |
		  parts do: [ :each | (each at: 'type' ifAbsent: [ nil ]) = 'text' ifTrue: [ stream << (each at: 'text' ifAbsent: [ '' ]) ] ] ]
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> appendTuiPrompt: aString [

	  ^ self post: '/tui/append-prompt' json: (Dictionary with: 'body' -> aString)
]

{ #category : 'info' }
PulsarLLMOpenCodeAPI >> authorizeOAuthProvider: aProviderID [

	  ^ self post: '/provider/' , aProviderID , '/oauth/authorize' json: Dictionary new
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> baseUrl [

	^ 'http://' , host , ':' , port asString
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> childrenOfSession: aSessionID [

	^ self get: '/session/' , aSessionID , '/children'
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> clearTuiPrompt [

	  ^ self post: '/tui/clear-prompt' json: Dictionary new
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> commands [

	  ^ self get: '/command'
]

{ #category : 'info' }
PulsarLLMOpenCodeAPI >> config [

	^ self get: '/config'
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> createSession: aTitle [

	| payload |
	payload := aTitle ifNil: [ Dictionary new ] ifNotNil: [ Dictionary with: 'title' -> aTitle ].
	^ self post: '/session' json: payload
]

{ #category : 'project' }
PulsarLLMOpenCodeAPI >> currentPath [

	  ^ self get: '/path'
]

{ #category : 'project' }
PulsarLLMOpenCodeAPI >> currentProject [

	  ^ self get: '/project/current'
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> delete: aPath [

	| client |
	client := self newClient: (self urlFor: aPath).
	client delete.
	self validate: client.
	^ self parseJSON: client contents
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> deleteSession: aSessionID [

	^ self delete: '/session/' , aSessionID
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> diffForSession: aSessionID messageID: aMessageID [

	| path |
	path := '/session/' , aSessionID , '/diff'.
	aMessageID ifNotNil: [ path := path , '?messageID=' , aMessageID ].
	^ self get: path
]

{ #category : 'instance' }
PulsarLLMOpenCodeAPI >> disposeInstance [
	  "Dispose the current OpenCode server instance. This stops the server, so use with care."

	  ^ self post: '/instance/dispose' json: Dictionary new
]

{ #category : 'events' }
PulsarLLMOpenCodeAPI >> eventsDo: aBlock [
	    "Consume the OpenCode event stream. The block receives the event name and its parsed
	JSON payload for each event, and a final invocation with nil, nil when the stream ends."

	    ^ self streamEventsFrom: '/event' do: aBlock
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> executeCommand: aCommand arguments: aDictionary inSession: aSessionID model: aModel agent: anAgent [

	  | payload |
	  payload := Dictionary new
		             at: 'command' put: aCommand;
		             at: 'arguments' put: aDictionary;
		             yourself.
	  aModel ifNotNil: [ payload at: 'model' put: aModel ].
	  anAgent ifNotNil: [ payload at: 'agent' put: anAgent ].
	  ^ self post: '/session/' , aSessionID , '/command' json: payload
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> executeTuiCommand: aString [

	    ^ self post: '/tui/execute-command' json: (Dictionary with: 'command' -> aString)
]

{ #category : 'tools' }
PulsarLLMOpenCodeAPI >> experimentalToolIDs [

	  ^ self get: '/experimental/tool/ids'
]

{ #category : 'tools' }
PulsarLLMOpenCodeAPI >> experimentalToolsForProvider: aProvider model: aModel [

	  ^ self get: '/experimental/tool' query: (Dictionary with: 'provider' -> aProvider with: 'model' -> aModel)
]

{ #category : 'files' }
PulsarLLMOpenCodeAPI >> fileContent: aPath [

	  ^ self get: '/file/content' query: (Dictionary with: 'path' -> aPath)
]

{ #category : 'files' }
PulsarLLMOpenCodeAPI >> fileStatus [

	  ^ self get: '/file/status'
]

{ #category : 'files' }
PulsarLLMOpenCodeAPI >> fileTree: aPath [

	  ^ self get: '/file' query: (Dictionary with: 'path' -> aPath)
]

{ #category : 'files' }
PulsarLLMOpenCodeAPI >> findFileNamed: aQuery type: aType directory: aDirectory limit: aLimit [

	  | query |
	  query := Dictionary with: 'query' -> aQuery.
	  aType ifNotNil: [ query at: 'type' put: aType ].
	  aDirectory ifNotNil: [ query at: 'directory' put: aDirectory ].
	  aLimit ifNotNil: [ query at: 'limit' put: aLimit ].
	  ^ self get: '/find/file' query: query
]

{ #category : 'files' }
PulsarLLMOpenCodeAPI >> findPattern: aPattern [

	  ^ self get: '/find' query: (Dictionary with: 'pattern' -> aPattern)
]

{ #category : 'files' }
PulsarLLMOpenCodeAPI >> findSymbol: aQuery [

	  ^ self get: '/find/symbol' query: (Dictionary with: 'query' -> aQuery)
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> forkSession: aSessionID messageID: aMessageID [

	  | payload |
	  payload := aMessageID ifNil: [ Dictionary new ] ifNotNil: [ Dictionary with: 'messageID' -> aMessageID ].
	  ^ self post: '/session/' , aSessionID , '/fork' json: payload
]

{ #category : 'system' }
PulsarLLMOpenCodeAPI >> formatterStatus [

	  ^ self get: '/formatter'
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> get: aPath [

	| client |
	client := self newClient: (self urlFor: aPath).
	client get.
	self validate: client.
	^ self parseJSON: client contents
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> get: aPath query: aDictionary [

	| client |
	client := self newClient: (self urlFor: aPath).
	aDictionary keysAndValuesDo: [ :eachKey :eachValue | client queryAt: eachKey put: eachValue ].
	client get.
	self validate: client.
	^ self parseJSON: client contents
]

{ #category : 'events' }
PulsarLLMOpenCodeAPI >> globalEventsDo: aBlock [
	    "Consume the global OpenCode event stream. The block receives the event name and its
	parsed JSON payload for each event, and a final invocation with nil, nil when the stream ends."

	    ^ self streamEventsFrom: '/global/event' do: aBlock
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> handlePartDelta: aProperties kinds: aCollection partTypes: aPartTypeMap text: aWriteStream do: aBlock [

	| partID field delta kind |
	field := aProperties at: 'field' ifAbsent: [ nil ].
	field = 'text' ifFalse: [ ^ self ].

	partID := aProperties at: 'partID' ifAbsent: [ nil ].
	delta := aProperties at: 'delta' ifAbsent: [ '' ].
	kind := (aPartTypeMap at: partID ifAbsent: [ 'text' ]) = 'reasoning'
		        ifTrue: [ #reasoning ]
		        ifFalse: [ #text ].
	(aCollection includes: kind) ifFalse: [ ^ self ].

	kind = #text ifTrue: [ aWriteStream nextPutAll: delta ].
	aBlock value: delta value: kind
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> handlePartUpdate: aPart kinds: aCollection partTypes: aPartTypeMap toolStates: aToolStateMap do: aBlock [

	| partID partType |
	partID := aPart at: 'id' ifAbsent: [ ^ self ].
	partType := aPart at: 'type' ifAbsent: [ ^ self ].
	aPartTypeMap at: partID put: partType.

	(partType = 'tool' and: [ aCollection includes: #tool ]) ifTrue: [
			| status |
			status := (aPart at: 'state' ifAbsent: [ nil ]) ifNotNil: [ :state | state at: 'status' ifAbsent: [ nil ] ].
			(aToolStateMap at: partID ifAbsent: [ nil ]) = status ifFalse: [
					aToolStateMap at: partID put: status.
					aBlock value: (self toolStreamLineFor: aPart) value: #tool ] ].

	((partType = 'step-start' or: [ partType = 'step-finish' ]) and: [ aCollection includes: #step ]) ifTrue: [
		aBlock value: (self stepStreamLineFor: aPart) value: #step ]
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> handleStreamType: aType properties: aProperties kinds: aCollection partTypes: aPartTypeMap toolStates: aToolStateMap text: aWriteStream do: aBlock [

	aType = 'message.part.updated' ifTrue: [
			self
				handlePartUpdate: (aProperties at: 'part' ifAbsent: [ Dictionary new ])
				kinds: aCollection
				partTypes: aPartTypeMap
				toolStates: aToolStateMap
				do: aBlock ].
	aType = 'message.part.delta' ifTrue: [
			self
				handlePartDelta: aProperties
				kinds: aCollection
				partTypes: aPartTypeMap
				text: aWriteStream
				do: aBlock ].
	aType = 'session.error' ifTrue: [ aBlock value: 'session error' value: #error ]
]

{ #category : 'health' }
PulsarLLMOpenCodeAPI >> health [

	^ self get: '/global/health'
]

{ #category : 'accessing' }
PulsarLLMOpenCodeAPI >> host [

	^ host
]

{ #category : 'accessing' }
PulsarLLMOpenCodeAPI >> host: anObject [

	host := anObject
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> initSession: aSessionID messageID: aMessageID providerID: aProviderID modelID: aModelID [

	  | payload |
	  payload := Dictionary new.
	  aMessageID ifNotNil: [ payload at: 'messageID' put: aMessageID ].
	  aProviderID ifNotNil: [ payload at: 'providerID' put: aProviderID ].
	  aModelID ifNotNil: [ payload at: 'modelID' put: aModelID ].
	  ^ self post: '/session/' , aSessionID , '/init' json: payload
]

{ #category : 'initialization' }
PulsarLLMOpenCodeAPI >> initialize [

	host := self class defaultHost.
	port := self class defaultPort.
	timeout := 600.
	super initialize
]

{ #category : 'health' }
PulsarLLMOpenCodeAPI >> isHealthy [

	^ [ (self health at: 'healthy') = true ]
		  on: Error
		  do: [ :e | false ]
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> jsonEncode: anObject [

	^ STONJSON toString: anObject
]

{ #category : 'logging' }
PulsarLLMOpenCodeAPI >> log: aService level: aLevel message: aMessage extra: aDictionary [

	  | payload |
	  payload := Dictionary new
		             at: 'service' put: aService;
		             at: 'level' put: aLevel;
		             at: 'message' put: aMessage;
		             yourself.
	  aDictionary ifNotNil: [ payload at: 'extra' put: aDictionary ].
	  ^ self post: '/log' json: payload
]

{ #category : 'system' }
PulsarLLMOpenCodeAPI >> lspStatus [

	  ^ self get: '/lsp'
]

{ #category : 'system' }
PulsarLLMOpenCodeAPI >> mcpStatus [

	  ^ self get: '/mcp'
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> message: aMessageID inSession: aSessionID [

	^ self get: '/session/' , aSessionID , '/message/' , aMessageID
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> messagesInSession: aSessionID [

	^ self get: '/session/' , aSessionID , '/message'
]

{ #category : 'accessing' }
PulsarLLMOpenCodeAPI >> model [
	"it can be nil"

	^ model
]

{ #category : 'accessing' }
PulsarLLMOpenCodeAPI >> model: aString [
	"e.g. deepseek-flash"

	model := aString
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> newClient: aUrl [

	^ ZnClient new
		url: aUrl;
		username: 'opencode' password: self serverPassword;
		timeout: self timeout;
		accept: ZnMimeType applicationJson;
		yourself
]

{ #category : 'instance creation' }
PulsarLLMOpenCodeAPI >> newSession [

	^ PulsarLLMAgentSession on: self
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> nextSSELineFrom: aReadStream [
	    "Read one line from aReadStream, handling CR, LF, and CRLF line endings.
	The stream returns raw bytes which are decoded as UTF-8."

	    | eol byte line |
	    aReadStream atEnd ifTrue: [ ^ nil ].
	    line := ByteArray new writeStream.
	    eol := false.
	    [ eol ] whileFalse: [
			    aReadStream atEnd
				    ifTrue: [ eol := true ]
				    ifFalse: [
						    byte := aReadStream next.
						    byte = 13
							    ifTrue: [
									    eol := true.
									    (aReadStream atEnd not and: [ aReadStream peek = 10 ]) ifTrue: [ aReadStream next ] ]
							    ifFalse: [
									    byte = 10
										    ifTrue: [ eol := true ]
										    ifFalse: [ line nextPut: byte ] ] ] ].
	    ^ line contents utf8Decoded
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> nextTuiControlRequest [
	    "This is a long-poll request that blocks until a control request is available."

	    ^ self get: '/tui/control/next'
]

{ #category : 'info' }
PulsarLLMOpenCodeAPI >> oauthCallbackForProvider: aProviderID [

	  ^ self post: '/provider/' , aProviderID , '/oauth/callback' json: Dictionary new
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> openTuiHelp [

	  ^ self post: '/tui/open-help' json: Dictionary new
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> openTuiModels [

	  ^ self post: '/tui/open-models' json: Dictionary new
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> openTuiSessions [

	  ^ self post: '/tui/open-sessions' json: Dictionary new
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> openTuiThemes [

	  ^ self post: '/tui/open-themes' json: Dictionary new
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> parseJSON: aString [

	(aString isNil or: [ aString isEmpty ]) ifTrue: [ ^ nil ].
	^ STONJSON fromString: aString
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> parseSSEFrom: aReadStream do: aBlock [
	    "Parse a server-sent events stream, invoking aBlock with the event name and the parsed
	JSON payload of each event. A final invocation with nil, nil signals that the stream ended."

	    | eventName data line payload |
	    eventName := 'message'.
	    data := nil.
	    [ aReadStream atEnd ] whileFalse: [
			    line := self nextSSELineFrom: aReadStream.
			    line isEmpty
				    ifTrue: [
						    data ifNotNil: [ aBlock value: eventName value: (self parseJSON: data) ].
						    eventName := 'message'.
						    data := nil ]
				    ifFalse: [
						    (line beginsWith: ':') ifFalse: [
								    (line beginsWith: 'event:')
									    ifTrue: [ eventName := line copyFrom: 7 to: line size ]
									    ifFalse: [
											    (line beginsWith: 'data:') ifTrue: [
													    payload := line copyFrom: 6 to: line size.
													    data := data ifNil: [ payload ] ifNotNil: [ data , String cr , payload ] ] ] ] ] ].
	    aBlock value: nil value: nil
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> patch: aPath json: aDictionary [

	| client |
	client := self newClient: (self urlFor: aPath).
	client
		entity: (ZnEntity with: (self jsonEncode: aDictionary) type: ZnMimeType applicationJson);
		patch.
	self validate: client.
	^ self parseJSON: client contents
]

{ #category : 'accessing' }
PulsarLLMOpenCodeAPI >> port [

	^ port
]

{ #category : 'accessing' }
PulsarLLMOpenCodeAPI >> port: anObject [

	port := anObject
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> post: aPath json: aDictionary [

	| client |
	client := self newClient: (self urlFor: aPath).
	client
		entity: (ZnEntity with: (self jsonEncode: aDictionary) type: ZnMimeType applicationJson);
		post.
	self validate: client.
	^ self parseJSON: client contents
]

{ #category : 'project' }
PulsarLLMOpenCodeAPI >> projects [

	  ^ self get: '/project'
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> promptPayloadFor: aString model: aModel agent: anAgent [
	  | payload |
	  
	  payload := OrderedDictionary new
		at: 'parts' put: { (Dictionary with: 'type' -> 'text' with: 'text' -> aString) };
		yourself.
		
	  aModel ifNotNil: [ 
	  	payload 
	  		at: 'model' 
	  		put: (Dictionary 
	  			with: 'providerID' -> (aModel copyUpTo: $/)
	  			with: 'modelID' -> (aModel copyAfter: $/)) ].

	  anAgent ifNotNil: [ payload at: 'agent' put: anAgent ].
	  
	  ^ payload
]

{ #category : 'info' }
PulsarLLMOpenCodeAPI >> providerAuthMethods [

	  ^ self get: '/provider/auth'
]

{ #category : 'info' }
PulsarLLMOpenCodeAPI >> providerStatus [

	  ^ self get: '/provider'
]

{ #category : 'info' }
PulsarLLMOpenCodeAPI >> providers [

	^ self get: '/config/providers'
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> put: aPath json: aDictionary [

	| client |
	client := self newClient: (self urlFor: aPath).
	client
		entity: (ZnEntity with: (self jsonEncode: aDictionary) type: ZnMimeType applicationJson);
		put.
	self validate: client.
	^ self parseJSON: client contents
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> renameSession: aSessionID to: aTitle [

	^ self patch: '/session/' , aSessionID json: (Dictionary with: 'title' -> aTitle)
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> respondToPermissionID: aPermissionID inSession: aSessionID response: aResponse remember: aBoolean [

	  | payload |
	  payload := Dictionary with: 'response' -> aResponse.
	  aBoolean ifNotNil: [ payload at: 'remember' put: aBoolean ].
	  ^ self post: '/session/' , aSessionID , '/permissions/' , aPermissionID json: payload
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> respondToTuiControlRequest: aBody [

	    ^ self post: '/tui/control/response' json: (Dictionary with: 'body' -> aBody)
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> revertMessageID: aMessageID partID: aPartID inSession: aSessionID [

	  | payload |
	  payload := Dictionary with: 'messageID' -> aMessageID.
	  aPartID ifNotNil: [ payload at: 'partID' put: aPartID ].
	  ^ self post: '/session/' , aSessionID , '/revert' json: payload
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> runShellCommand: aCommand inSession: aSessionID model: aModel agent: anAgent [

	  | payload |
	  payload := Dictionary with: 'command' -> aCommand.
	  aModel ifNotNil: [ payload at: 'model' put: aModel ].
	  anAgent ifNotNil: [ payload at: 'agent' put: anAgent ].
	  ^ self post: '/session/' , aSessionID , '/shell' json: payload
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> sendText: aString toSession: aSessionID [

	^ self
		  sendText: aString
		  toSession: aSessionID
		  model: self model
		  agent: nil
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> sendText: aString toSession: aSessionID do: aBlock [
	"Send a text prompt and stream the answer chunks to aBlock until the turn ends."

	^ self
		  sendText: aString
		  toSession: aSessionID
		  kinds: self class defaultStreamKinds
		  do: aBlock
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> sendText: aString toSession: aSessionID kinds: aCollection do: aBlock [
	"Send a text prompt and stream the answer to aBlock until the turn ends.
	 aBlock receives a chunk String and a kind Symbol among #text, #reasoning,
	 #tool, #step and #error. Answers the accumulated text of the #text chunks."
	| ready finished partTypes toolStates text |
	
	ready := Semaphore new.
	finished := Semaphore new.
	partTypes := Dictionary new.
	toolStates := Dictionary new.
	text := WriteStream on: String new.

	self
		subscribeSession: aSessionID
		kinds: aCollection
		ready: ready
		finished: finished
		partTypes: partTypes
		toolStates: toolStates
		text: text
		do: aBlock.

	ready waitTimeoutSeconds: 5.
	self
		sendTextAsync: aString
		toSession: aSessionID
		model: self model
		agent: nil.
	(finished waitTimeoutSeconds: self timeout) ifTrue: [ aBlock value: 'stream timed out' value: #error ].
	^ text contents
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> sendText: aString toSession: aSessionID model: aModel agent: anAgent [
	"Send a text prompt and wait for the reply."

	^ self 
		post: '/session/' , aSessionID , '/message' 
		json: (self 
			promptPayloadFor: aString 
			model: aModel 
			agent: anAgent)
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> sendTextAsync: aString toSession: aSessionID [
	"Send a text prompt without waiting for the reply, using the current model."

	^ self
		  sendTextAsync: aString
		  toSession: aSessionID
		  model: self model
		  agent: nil
]

{ #category : 'messages' }
PulsarLLMOpenCodeAPI >> sendTextAsync: aString toSession: aSessionID model: aModel agent: anAgent [
	  "Send a text prompt without waiting for the reply."

	  ^ self post: '/session/' , aSessionID , '/prompt_async' json: (self promptPayloadFor: aString model: aModel agent: anAgent)
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> serverPassword [

	^ OSEnvironment current at: #OPENCODE_SERVER_PASSWORD
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> session: aSessionID [

	^ self get: '/session/' , aSessionID
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> sessionStatus [

	  ^ self get: '/session/status'
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> sessions [

	^ self get: '/session'
]

{ #category : 'info' }
PulsarLLMOpenCodeAPI >> setAuthCredentials: aDictionary forProviderID: aProviderID [

	  ^ self put: '/auth/' , aProviderID json: aDictionary
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> shareSession: aSessionID [

	  ^ self post: '/session/' , aSessionID , '/share' json: Dictionary new
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> showTuiToast: aMessage title: aTitle variant: aVariant [

	    | payload |
	    payload := Dictionary with: 'message' -> aMessage with: 'variant' -> aVariant.
	    aTitle ifNotNil: [ payload at: 'title' put: aTitle ].
	    ^ self post: '/tui/show-toast' json: payload
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> showTuiToast: aMessage variant: aVariant [

	    ^ self showTuiToast: aMessage title: nil variant: aVariant
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> stepStreamLineFor: aPart [

	^ '[step] ' , (aPart at: 'type' ifAbsent: [ 'step' ]) , String cr
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> streamEventsFrom: aPath do: aBlock [

	    | client stream |
	    client := self newClient: (self urlFor: aPath).
	    client streaming: true.
	    client get.
	    self validate: client.
	    stream := client contents.
	    [ self parseSSEFrom: stream do: aBlock ] ensure: [ stream close ]
]

{ #category : 'tui' }
PulsarLLMOpenCodeAPI >> submitTuiPrompt [

	    ^ self post: '/tui/submit-prompt' json: Dictionary new
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> subscribeSession: aSessionID kinds: aCollection ready: aReady finished: aFinished partTypes: aPartTypeMap toolStates: aToolStateMap text: aWriteStream do: aBlock [
	"Fork a process that streams the OpenCode events for aSessionID until the turn ends."

	[
		[
			self eventsDo: [ :eachEventName :eachEventData |
					eachEventData isDictionary ifTrue: [
							| type properties |
							type := eachEventData at: 'type' ifAbsent: [ nil ].
							properties := eachEventData at: 'properties' ifAbsent: [ nil ].
							type = 'server.connected' ifTrue: [ aReady signal ].
							(properties isDictionary and: [ (properties at: 'sessionID' ifAbsent: [ nil ]) = aSessionID ]) ifTrue: [
									self
										handleStreamType: type
										properties: properties
										kinds: aCollection
										partTypes: aPartTypeMap
										toolStates: aToolStateMap
										text: aWriteStream
										do: aBlock.
									(type = 'session.idle' or: [ type = 'session.error' ]) ifTrue: [ PulsarLLMStreamStop signal ] ] ] ] ]
			on: Error
			do: [ :e |
					(e isKindOf: PulsarLLMStreamStop) ifFalse: [ aBlock value: 'stream error: ' , e description value: #error ].
					aFinished signal ] ] fork
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> summarizeSession: aSessionID providerID: aProviderID modelID: aModelID [

	  | payload |
	  payload := Dictionary new
		             at: 'providerID' put: aProviderID;
		             at: 'modelID' put: aModelID;
		             yourself.
	  ^ self post: '/session/' , aSessionID , '/summarize' json: payload
]

{ #category : 'accessing' }
PulsarLLMOpenCodeAPI >> timeout [

	^ timeout
]

{ #category : 'accessing' }
PulsarLLMOpenCodeAPI >> timeout: anObject [

	timeout := anObject
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> todosOfSession: aSessionID [

	^ self get: '/session/' , aSessionID , '/todo'
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> toolStreamLineFor: aPart [

	| status |
	status := (aPart at: 'state' ifAbsent: [ nil ])
		          ifNotNil: [ :state | state at: 'status' ifAbsent: [ 'pending' ] ]
		          ifNil: [ 'pending' ].
	^ '[tool] ' , (aPart at: 'tool' ifAbsent: [ '?' ]) , ' (' , status asString , ')' , String cr
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> unrevertSession: aSessionID [

	  ^ self post: '/session/' , aSessionID , '/unrevert' json: Dictionary new
]

{ #category : 'sessions' }
PulsarLLMOpenCodeAPI >> unshareSession: aSessionID [

	  ^ self delete: '/session/' , aSessionID , '/share'
]

{ #category : 'info' }
PulsarLLMOpenCodeAPI >> updateConfig: aDictionary [

	  ^ self patch: '/config' json: aDictionary
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> urlFor: aPath [

	^ (aPath beginsWith: '/')
		  ifTrue: [ self baseUrl , aPath ]
		  ifFalse: [ self baseUrl , '/' , aPath ]
]

{ #category : 'private' }
PulsarLLMOpenCodeAPI >> validate: aClient [
	"Raise an error when the server answered with a non-success status."

	aClient response isSuccess ifFalse: [
		self error: 'OpenCode API error ' , aClient response statusLine asString , String cr , (aClient response contents first: 300) ]
]

{ #category : 'project' }
PulsarLLMOpenCodeAPI >> vcsInfo [

	  ^ self get: '/vcs'
]
