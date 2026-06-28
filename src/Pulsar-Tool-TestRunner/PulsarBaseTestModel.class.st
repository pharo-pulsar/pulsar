"
Abstract base for test runner models (suites and cases). Provides common selection state, icon resolution, and entity model conversion.
"
Class {
	#name : 'PulsarBaseTestModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'isSelected'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'converting' }
PulsarBaseTestModel >> asEntityModel [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
PulsarBaseTestModel >> iconName [

	^ self statusIconForModel
]

{ #category : 'accessing' }
PulsarBaseTestModel >> isSelected [

	isSelected ifNil: [ isSelected := true ].
	^ isSelected
]

{ #category : 'accessing' }
PulsarBaseTestModel >> isSelected: aBoolean [

	isSelected := aBoolean
]

{ #category : 'private' }
PulsarBaseTestModel >> statusIconForModel [

	self asEntityModel lastTestExecutionResult ifNotNil: [ :aResult |
			aResult hasErrors ifTrue: [ ^ 'run-test-error' ].
			aResult hasFailures ifTrue: [ ^ 'run-test-failure' ].
			aResult hasPassed ifTrue: [ ^ 'run-test-passed' ] ].
	^ 'run-test'
]
