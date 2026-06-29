Class {
	#name : 'PulsarMethodActionRunTestPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'buttonPresenter'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'private - accessing' }
PulsarMethodActionRunTestPresenter >> contextModel [

	^ self model ifNotNil: [ :aModel | aModel context model ]
	
]

{ #category : 'layout' }
PulsarMethodActionRunTestPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: buttonPresenter;
		yourself
]

{ #category : 'executing' }
PulsarMethodActionRunTestPresenter >> execute [

	self model execute
]

{ #category : 'initialization' }
PulsarMethodActionRunTestPresenter >> initializePresenters [

	buttonPresenter := self newButton
		addStyle: 'small';
		addStyle: 'flat';
		help: 'Execute test';
		icon: (self iconNamed: 'play');
		action: [ self execute ]
]

{ #category : 'private' }
PulsarMethodActionRunTestPresenter >> statusIconForModel [
 
	self contextModel lastTestExecutionResult ifNotNil: [ :aResult | 
		aResult hasErrors ifTrue: [ ^ 'run-test-error' ].	
		aResult hasFailures ifTrue: [ ^ 'run-test-failure' ].	
		aResult hasEffectivePassed ifTrue: [ ^ 'run-test-passed' ] ].	
		
	^ 'test-not-run'
]

{ #category : 'initialization' }
PulsarMethodActionRunTestPresenter >> updatePresenter [

	self contextModel ifNil: [ ^ self ]. 
	
	buttonPresenter icon: (self iconNamed: self statusIconForModel)
]
