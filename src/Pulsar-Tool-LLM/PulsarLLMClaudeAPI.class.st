"
I am a client for the Claude Code CLI, used as an LLM agent backend in Pulsar. Unlike the OpenCode client, I do not talk to a server. Each Pulsar session gets its own long-lived `claude` process, which keeps the conversation context across turns, so I only write user messages to it and read back the events it streams.

I offer the vocabulary that `PulsarLLMAgentSession` expects: sessions are created, messaged, aborted and deleted by id, and replies arrive as chunks tagged with a kind (text, reasoning, tool, tool error, error). I manage the sessions and their configuration. The process itself and the translation of its events into chunks belong to `PulsarLLMClaudeProcess`.

Things worth knowing:

- Claude runs in non-bare mode, so the normal Claude authentication is used.
- Permission prompts are skipped, so tools run without interaction.
- The working directory defaults to the image directory, where the `.mcp.json` prepared by `PulsarLLMClaudeModel` is discovered.
- Thinking is on by default and follows the application's `thinking` setting.

Example:

```smalltalk
| api sessionID |
api := PulsarLLMClaudeAPI new.
sessionID := (api createSession: 'Pharo stream example') at: 'id'.
api
	sendText: 'Count from 1 to 5.'
	toSession: sessionID
	do: [ :chunk :kind | Transcript show: '[', kind asString, '] ', chunk; cr ].
api deleteSession: sessionID
```

See also `PulsarLLMClaudeAPI class>>#exampleStream` and `PulsarLLMClaudeAPI class>>#exampleConversation`.
"
Class {
	#name : 'PulsarLLMClaudeAPI',
	#superclass : 'Object',
	#instVars : [
		'sessions',
		'sessionsMutex',
		'model',
		'timeout',
		'workingDirectory',
		'thinking'
	],
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'defaults' }
PulsarLLMClaudeAPI class >> defaultAgentModel [

	^ nil
]

{ #category : 'defaults' }
PulsarLLMClaudeAPI class >> defaultStreamKinds [

	^ #( #text #reasoning #tool )
]

{ #category : 'examples' }
PulsarLLMClaudeAPI class >> exampleConversation [
	"PulsarLLMClaudeAPI exampleConversation"
	| api sessionID first second |

	api := self new.
	sessionID := (api createSession: 'Pharo context example') at: 'id'.
	first := api answerTextFrom: (api sendText: 'Remember the number 41. Reply only OK.' toSession: sessionID).
	second := api answerTextFrom: (api
		sendText: 'What number did I ask you to remember? Reply with the number only.'
		toSession: sessionID).

	api deleteSession: sessionID.

	^ { first. second }
]

{ #category : 'examples' }
PulsarLLMClaudeAPI class >> examplePrompt [
	"PulsarLLMClaudeAPI examplePrompt"
	| api sessionID reply |
	
	api := self new.
	sessionID := (api createSession: 'Pharo example') at: 'id'.
	
	reply := api answerTextFrom: (api sendText: 'Hello from Pharo! What is 40 + 2?' toSession: sessionID).
	api deleteSession: sessionID.
	
	^ reply
]

{ #category : 'examples' }
PulsarLLMClaudeAPI class >> exampleStream [
	"PulsarLLMClaudeAPI exampleStream"
	| api sessionID reply |

	api := self new.
	sessionID := (api createSession: 'Pharo stream example') at: 'id'.

	reply := api
		sendText: 'Count from 1 to 5.'
		toSession: sessionID
		do: [ :chunk :kind | ('[' , kind asString , '] ' , chunk) traceCr ].

	api deleteSession: sessionID.

	^ reply
]

{ #category : 'testing' }
PulsarLLMClaudeAPI class >> isAvailable [

	^ (PulsarWhich pathOfProgram: 'claude') isNotNil
]

{ #category : 'sessions' }
PulsarLLMClaudeAPI >> abortSession: aSessionID [
	| process |
	
	process := sessionsMutex critical: [ 
		sessions at: aSessionID ifAbsent: [ nil ] ].
	process ifNotNil: [ process abort ].
	
	^ self
]

{ #category : 'messages' }
PulsarLLMClaudeAPI >> answerTextFrom: aResponse [
	| errors content blocks |
	
	aResponse ifNil: [ ^ '' ].
	aResponse isString ifTrue: [ ^ aResponse ].
	aResponse isDictionary ifFalse: [ ^ aResponse asString ].
	(aResponse at: 'result' ifAbsent: [ nil ]) ifNotNil: [ :each | ^ each ].
	
	errors := aResponse at: 'errors' ifAbsent: [ nil ].
	errors ifNotNil: [
		^ String streamContents: [ :stream | 
			errors 
				do: [ :each | stream << each ] 
				separatedBy: [ stream << String lf ] ] ].
	content := aResponse at: 'message' ifAbsent: [ nil ].
	content ifNil: [ ^ '' ].	

	blocks := content at: 'content' ifAbsent: [ #(  ) ].
	String streamContents: [ :stream |
		blocks do: [ :each | 
			(each at: 'type' ifAbsent: [ nil ]) = 'text' 
				ifTrue: [ stream << (each at: 'text' ifAbsent: [ '' ]) ] ] ]
]

{ #category : 'sessions' }
PulsarLLMClaudeAPI >> closeAll [
	| all |
	
	all := sessionsMutex critical: [
		| copy |
		copy := sessions values asArray.
		sessions removeAll.
		copy ].

	all do: [ :each | each stop ]
]

{ #category : 'private' }
PulsarLLMClaudeAPI >> commandAndArgumentsFor: aProcess [

	| claudePath args |
	claudePath := PulsarWhich pathOfProgram: 'claude'.
	claudePath ifNil: [ self error: 'Claude not found. Please install it and make sure it can be found in the PATH.' ].

	args := OrderedCollection new.
	args
		add: '--print';
		add: '--input-format';
		add: 'stream-json';
		add: '--output-format';
		add: 'stream-json';
		add: '--verbose';
		add: '--include-partial-messages';
		add: '--dangerously-skip-permissions';
		add: '--session-id';
		add: aProcess sessionId.

	self thinking
		ifTrue: [
				args
					add: '--thinking=adaptive';
					add: '--thinking-display=summarized' ]
		ifFalse: [ args add: '--thinking=disabled' ].

	self model ifNotNil: [ :each |
			args
				add: '--model';
				add: each ].

	aProcess title ifNotNil: [ :each |
			args
				add: '--name';
				add: each ].

	^ OSPlatform current isFlatpak
		  ifTrue: [
				  | flatpakArgs |
				  flatpakArgs := OrderedCollection new.
				  flatpakArgs addAll: #( '--host' '--watch-bus' ).
				  flatpakArgs add: '--directory=' , self workingDirectoryReference fullName.
				  flatpakArgs add: claudePath.
				  flatpakArgs addAll: args.
				  {
					  'flatpak-spawn'.
					  flatpakArgs asArray } ]
		  ifFalse: [
				  {
					  claudePath.
					  args asArray } ]
]

{ #category : 'sessions' }
PulsarLLMClaudeAPI >> createSession: aTitle [
	| sessionID process |
	
	sessionID := UUID new asString.
	process := PulsarLLMClaudeProcess api: self id: sessionID title: aTitle.
	sessionsMutex critical: [ 
		sessions at: sessionID put: process ].
	
	^ Dictionary with: 'id' -> sessionID
]

{ #category : 'sessions' }
PulsarLLMClaudeAPI >> deleteSession: aSessionID [
	| process |
	
	process := sessionsMutex critical: [ 
		sessions removeKey: aSessionID ifAbsent: [ nil ] ].
	process ifNotNil: [ process stop ]
]

{ #category : 'private' }
PulsarLLMClaudeAPI >> ensureConfiguration [

	"Nothing for now"
	"Maybe we will need something like this: PulsarLLMClaudeModel new ensureConfig"
]

{ #category : 'initialization' }
PulsarLLMClaudeAPI >> initialize [

	sessions := Dictionary new.
	sessionsMutex := Mutex new.
	timeout := 600.
	workingDirectory := FileLocator imageDirectory.
	thinking := true.
	super initialize
]

{ #category : 'accessing' }
PulsarLLMClaudeAPI >> model [

	^ model
]

{ #category : 'accessing' }
PulsarLLMClaudeAPI >> model: aString [

	model := aString
]

{ #category : 'sessions' }
PulsarLLMClaudeAPI >> newSession [

	^ PulsarLLMAgentSession on: self
]

{ #category : 'messages' }
PulsarLLMClaudeAPI >> sendText: aString toSession: aSessionID [

	^ self
		  sendText: aString
		  toSession: aSessionID
		  model: self model
		  agent: nil
]

{ #category : 'messages' }
PulsarLLMClaudeAPI >> sendText: aString toSession: aSessionID do: aBlock [

	^ self
		  sendText: aString
		  toSession: aSessionID
		  kinds: self class defaultStreamKinds
		  do: aBlock
]

{ #category : 'messages' }
PulsarLLMClaudeAPI >> sendText: aString toSession: aSessionID kinds: aCollection do: aBlock [
	| turn |
	
	turn := (self sessionAt: aSessionID) 
		runTurn: aString 
		kinds: aCollection 
		do: aBlock.
	
	^ turn at: 'text'
]

{ #category : 'messages' }
PulsarLLMClaudeAPI >> sendText: aString toSession: aSessionID model: aModel agent: anAgent [
	"Claude fixes the model at process start, so the per-turn model and agent are ignored."
	| turn |
	
	turn := (self sessionAt: aSessionID) 
		runTurn: aString 
		kinds: self class defaultStreamKinds 
		do: [ :chunk :kind | nil ].
	
	^ turn at: 'event'
]

{ #category : 'private' }
PulsarLLMClaudeAPI >> sessionAt: aSessionID [

	^ sessionsMutex critical: [ 
		sessions at: aSessionID ifAbsent: [ 
			self error: 'Unknown Claude session: ', aSessionID ] ]
]

{ #category : 'accessing' }
PulsarLLMClaudeAPI >> sessions [

	^ sessions
]

{ #category : 'accessing' }
PulsarLLMClaudeAPI >> thinking [

	^ thinking ifNil: [ true ]
]

{ #category : 'accessing' }
PulsarLLMClaudeAPI >> thinking: aBoolean [

	thinking := aBoolean
]

{ #category : 'accessing' }
PulsarLLMClaudeAPI >> timeout [

	^ timeout
]

{ #category : 'accessing' }
PulsarLLMClaudeAPI >> timeout: aNumber [

	timeout := aNumber
]

{ #category : 'accessing' }
PulsarLLMClaudeAPI >> workingDirectory [

	^ workingDirectory
]

{ #category : 'accessing' }
PulsarLLMClaudeAPI >> workingDirectory: aFileReferenceOrString [

	workingDirectory := aFileReferenceOrString asFileReference
]

{ #category : 'private' }
PulsarLLMClaudeAPI >> workingDirectoryReference [

	^ workingDirectory 
		ifNotNil: [ :each | each asFileReference ]
		ifNil: [ FileLocator imageDirectory ] 
]
