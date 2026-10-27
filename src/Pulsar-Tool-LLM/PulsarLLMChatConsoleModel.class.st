"
I am the model of the `PulsarLLMChatConsole` panel — the chat terminal used to converse with an external LLM client.

I carry the panel's configuration: which client class to run (such as `PulsarLLMClaudeModel`, `PulsarLLMCodexModel`, or `PulsarLLMOpenCodeModel`), an optional initial prompt to feed the session when it starts, and a flag (defaulting to true) deciding whether the console connects automatically when the panel opens. When the panel asks me to connect, I instantiate the configured client class, prepare it, and hook it up to the panel's `VteTerminalPresenter`, feeding it any pending initial prompt; the resulting live session is then held as my current client. The initial prompt is consumed at most once, even if the connection fails.

My `title` is derived from the selected client's `label`, so it reflects which LLM the panel is wired to.

```smalltalk
PulsarLLMChatConsoleModel new
    initialPrompt: 'Explain this class';
    yourself
```

`PulsarLLMChatConsole` auto-creates one of me when it lacks a model, and `PulsarLLMAgentModel` builds me with an `initialPrompt` and pushes me into a console by announcing `PulsarRequestNewLLMTerminal`.
"
Class {
	#name : 'PulsarLLMChatConsoleModel',
	#superclass : 'Object',
	#instVars : [
		'clientClass',
		'initialPrompt',
		'title',
		'autoConnect',
		'clientModel'
	],
	#category : 'Pulsar-Tool-LLM-Model',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarLLMChatConsoleModel >> autoConnect [

	^ autoConnect ifNil: [ true ]
]

{ #category : 'accessing' }
PulsarLLMChatConsoleModel >> autoConnect: aBoolean [

	autoConnect := aBoolean
]

{ #category : 'accessing' }
PulsarLLMChatConsoleModel >> clientClass [

	^ clientClass
]

{ #category : 'accessing' }
PulsarLLMChatConsoleModel >> clientClass: aClass [

	clientClass := aClass
]

{ #category : 'accessing' }
PulsarLLMChatConsoleModel >> clientModelLabel [ 

	^ self clientClass 
		ifNotNil: #label
		ifNil: [ 'Undefined' ]
]

{ #category : 'accessing' }
PulsarLLMChatConsoleModel >> connectTo: aTerminalPresenter [ 
	"Creates and prepares a new client session in aTerminalPresenter, sending the 
	 pending initial prompt once. The prompt is cleared even if the connection fails, 
	 and the new client becomes current; raises if no client class is configured."

	[ 
		(clientModel := self newClient) 
			prepare;
			connectTo: aTerminalPresenter withPrompt: self initialPrompt ]
	ensure: [
		"consumed"
		self initialPrompt: nil ]
]

{ #category : 'accessing' }
PulsarLLMChatConsoleModel >> initialPrompt [

	             ^ initialPrompt
]

{ #category : 'accessing' }
PulsarLLMChatConsoleModel >> initialPrompt: aString [

	initialPrompt := aString
]

{ #category : 'initialization' }
PulsarLLMChatConsoleModel >> initialize [

	super initialize.
	autoConnect := true
]

{ #category : 'factory' }
PulsarLLMChatConsoleModel >> newClient [

	self clientClass ifNil: [ self error: 'No LLM client selected.' ].
	^ self clientClass new
]

{ #category : 'copying' }
PulsarLLMChatConsoleModel >> postCopy [

	super postCopy.
	clientModel := nil
]

{ #category : 'snapshot' }
PulsarLLMChatConsoleModel >> prepareForSnapshot [
]

{ #category : 'accessing' }
PulsarLLMChatConsoleModel >> title [
	"Returns the label displayed for this chat console, combining the optional
	custom name with the label of the selected client model. The client label
	is Undefined when no client class is configured."

	^ f'Assistant \[[self clientModelLabel]]'
]
