Class {
	#name : 'DockMethodActionRunTestPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'buttonPresenter'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'private - accessing' }
DockMethodActionRunTestPresenter >> contextModel [

	^ self model ifNotNil: [ :aModel | aModel context model ]
	
]

{ #category : 'layout' }
DockMethodActionRunTestPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: buttonPresenter;
		yourself
]

{ #category : 'executing' }
DockMethodActionRunTestPresenter >> execute [

	self model execute
]

{ #category : 'initialization' }
DockMethodActionRunTestPresenter >> initializePresenters [

	buttonPresenter := self newButton
		addStyle: 'small';
		addStyle: 'flat';
		icon: (self iconNamed: 'play');
		action: [ self execute ]
]

{ #category : 'private' }
DockMethodActionRunTestPresenter >> statusIconForModel [

	self contextModel lastTestExecutionResult ifNotNil: [ :result | 
		result hasErrors ifTrue: [ ^ 'run-test-error' ].	
		result hasFailures ifTrue: [ ^ 'run-test-failure' ].	
		result hasPassed ifTrue: [ ^ 'run-test-passed' ] ].	
		
	^ 'run-test'
]

{ #category : 'initialization' }
DockMethodActionRunTestPresenter >> updatePresenter [

	self contextModel ifNil: [ ^ self ]. 
	
	buttonPresenter icon: (self iconNamed: self statusIconForModel)
]
