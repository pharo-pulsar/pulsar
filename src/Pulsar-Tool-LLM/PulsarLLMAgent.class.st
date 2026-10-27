"
I am the entry point that opens the LLM agent for a Pulsar tool. I am created from the context of what the user is looking at (a method, a class, a debugger, or a repository diff) and I turn that context into an agent session, so the conversation is anchored to that entity.

My responsibilities are to ask the caller model for a context-specific agent model, to instantiate a `PulsarLLMAgentPresenter` on it, and to show that presenter in a modal popover attached to the action that triggered me. I also wire the agent presenter to the caller's notification center when one is available, falling back to a null announcer otherwise, so the agent can report back to the surrounding tool.

I collaborate with:

- **Caller models** (`PvMethodModel`, `PvClassModel`, `PulsarDebuggerModel`, `PulsarRepositoryDiffEditor`): they provide the agent model through `newAgentModel` and the context the agent works on.
- **`PulsarLLMAgentPresenter`**: the agent user interface that I instantiate and display.
- **The caller presenter and action**: the presenter gives me access to the window and notification center, and the action is the popover anchor.

## Public API and Key Messages

- `PulsarLLMAgent class >> newModel:callerAction:callerPresenter:` creates an agent for a model and its caller.
- `show` displays the agent in a popover.

## Usage

I am created in dock action definitions, such as `PvMethodModel>>defineAgentActionsOn:`, each time the user activates the Agent action:

```smalltalk
action: [ :aContext |
	(PulsarLLMAgent
		newModel: self
		callerAction: action
		callerPresenter: aContext) show ]
```

See also `PvClassModel>>defineAgentActionsOn:`, `PulsarDebuggerModel>>defineAgentActionsOn:`, and `PulsarRepositoryDiffEditor>>defineAgentActionsOn:`.
"
Class {
	#name : 'PulsarLLMAgent',
	#superclass : 'Object',
	#instVars : [
		'api',
		'model',
		'callerAction',
		'callerPresenter',
		'agentPresenter'
	],
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'instance creation' }
PulsarLLMAgent class >> newModel: aModel callerAction: anAction callerPresenter: aPresenter [

	^ self basicNew
		initializeModel: aModel 
			callerAction: anAction
			callerPresenter: aPresenter;
		yourself
]

{ #category : 'accessing' }
PulsarLLMAgent >> agentPresenter [

	^ agentPresenter ifNil: [
			  agentPresenter := self newAgentPresenter.
			  agentPresenter notificationCenter: self callerNotificationCenter.
			  agentPresenter ]
]

{ #category : 'accessing' }
PulsarLLMAgent >> callerAction [

	^ callerAction
]

{ #category : 'accessing' }
PulsarLLMAgent >> callerNotificationCenter [
	"Answer the notification center to wire the agent presenter with.
	
	 Browser panels answer #notificationCenter, but plain window presenters may not, so fall back to the caller presenter own notification center."

	| window |
	window := [ self callerPresenter window ]
		          on: Error
		          do: [ :e | nil ].
	window ifNotNil: [ :each | (each respondsTo: #notificationCenter) ifTrue: [ ^ each notificationCenter ] ].
	^ (self callerPresenter respondsTo: #notificationCenter)
		  ifTrue: [ self callerPresenter notificationCenter ]
		  ifFalse: [ PulsarNULLAnnouncer new ]
]

{ #category : 'accessing' }
PulsarLLMAgent >> callerPresenter [

	^ callerPresenter
]

{ #category : 'initialization' }
PulsarLLMAgent >> initializeModel: aModel callerAction: anAction callerPresenter: aPresenter [ 

	model := aModel.
	callerAction := anAction. 
	callerPresenter := aPresenter.
	self initialize.
]

{ #category : 'accessing' }
PulsarLLMAgent >> model [

	^ model
]

{ #category : 'as yet undefined' }
PulsarLLMAgent >> newAgentPresenter [
	"Answer a new agent presenter instantiated by my caller presenter and wired to my model."

	^ self callerPresenter 
		instantiate: PulsarLLMAgentPresenter 
		on: self model newAgentModel
]

{ #category : 'showing' }
PulsarLLMAgent >> show [

	self agentPresenter asPopover
		relativeTo: self callerAction presenter;
		popupModal
]
