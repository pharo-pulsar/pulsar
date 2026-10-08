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

{ #category : 'private' }
PulsarLLMAgent >> agentPresenter [

	^ agentPresenter ifNil: [ self newAgentPresenter ]
]

{ #category : 'accessing' }
PulsarLLMAgent >> callerAction [

	^ callerAction
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

{ #category : 'private' }
PulsarLLMAgent >> newAgentPresenter [
	
	self subclassResponsibility
]

{ #category : 'showing' }
PulsarLLMAgent >> show [

	self agentPresenter asPopover
		relativeTo: self callerAction presenter;
		popupModal
]
