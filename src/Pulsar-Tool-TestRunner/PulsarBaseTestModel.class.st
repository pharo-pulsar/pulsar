"
Abstract base for test runner models (suites and cases). Provides common selection state, icon resolution, and entity model conversion.
"
Class {
	#name : 'PulsarBaseTestModel',
	#superclass : 'PvBaseModel',
	#category : 'Pulsar-Tool-TestRunner',
	#package : 'Pulsar-Tool-TestRunner'
}

{ #category : 'comparing' }
PulsarBaseTestModel >> = other [

	^ self species = other species
		and: [ self entity = other entity ]
]

{ #category : 'converting' }
PulsarBaseTestModel >> asEntityModel [

	^ self subclassResponsibility
]

{ #category : 'comparing' }
PulsarBaseTestModel >> hash [

	^ self species hash
		bitXor: self entity hash
]

{ #category : 'accessing' }
PulsarBaseTestModel >> iconName [

	^ self statusIconForModel
]

{ #category : 'running' }
PulsarBaseTestModel >> runOn: anActionContext [

	self subclassResponsibility
]

{ #category : 'accessing' }
PulsarBaseTestModel >> statusDescription [

	^ self asEntityModel lastTestExecutionResult ifNotNil: #asString
]

{ #category : 'private' }
PulsarBaseTestModel >> statusIconForModel [

	self asEntityModel lastTestExecutionResult ifNotNil: [ :aResult |
		aResult hasErrors ifTrue: [ ^ 'run-test-error' ].
		aResult hasFailures ifTrue: [ ^ 'run-test-failure' ].
		aResult hasEffectivePassed ifTrue: [ ^ 'run-test-passed' ] ].
	
	^ 'test-not-run'
]
