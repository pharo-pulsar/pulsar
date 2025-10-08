Class {
	#name : 'PvMethodTestDecorator',
	#superclass : 'PvMethodDecorator',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'testing' }
PvMethodTestDecorator class >> appliesTo: aMethod [

	^ aMethod isTestMethod
]

{ #category : 'accessing' }
PvMethodTestDecorator >> style [ 

	self model isTestError ifTrue: [ ^ 'test-error' ].
	self model isTestFailure ifTrue: [ ^ 'test-failure' ].
	self model isTestPassed ifTrue: [ ^ 'test-passed' ].

	^ 'test-unknown'
]
