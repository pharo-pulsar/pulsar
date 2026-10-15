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
