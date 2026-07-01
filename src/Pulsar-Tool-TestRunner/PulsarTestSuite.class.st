"
A test suite wrapping a TestCase subclass. Its entity is the Class.

Children are lazily-built PulsarTestCase instances, one per test selector.
"
Class {
	#name : 'PulsarTestSuite',
	#superclass : 'PulsarBaseTestModel',
	#instVars : [
		'cases'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'converting' }
PulsarTestSuite >> asEntityModel [

	^ PvClassModel 
		newEnvironment: self environmentModel
		entity: self entity
]

{ #category : 'accessing' }
PulsarTestSuite >> cases [

	^ cases ifNil: [ cases := self children ]
]

{ #category : 'accessing' }
PulsarTestSuite >> children [

	^ cases ifNil: [ cases := self collectCases ]
]

{ #category : 'accessing' }
PulsarTestSuite >> collectCases [

	^ self entity allTestSelectors collect: [ :eachSelector | 
		PulsarTestCase 
			newEnvironment: self environmentModel 
			parent: self 
			entity: (self entity selector: eachSelector) ]
]

{ #category : 'accessing' }
PulsarTestSuite >> description [

	^ self entity name
]

{ #category : 'accessing' }
PulsarTestSuite >> deselectAll [

	self children do: [ :each | each isSelected: false ]
]

{ #category : 'accessing' }
PulsarTestSuite >> iconName [

	^ self statusIconForModel
]

{ #category : 'accessing' }
PulsarTestSuite >> isSelected [
	"Return true if all cases are selected."

	^ self children allSatisfy: [ :each | each isSelected ]
]

{ #category : 'accessing' }
PulsarTestSuite >> name [

	^ self entity name
]

{ #category : 'running' }
PulsarTestSuite >> runOn: anActionContext [
	
	^ anActionContext doRunSuite: self
]

{ #category : 'accessing' }
PulsarTestSuite >> selectAll [

	self children do: [ :each | each isSelected: true ]
]

{ #category : 'accessing' }
PulsarTestSuite >> selectedCases [

	^ self children select: [ :each | each isSelected ]
]

{ #category : 'private' }
PulsarTestSuite >> statusIconForModel [
 
	self asEntityModel lastTestExecutionResult ifNotNil: [ :result | 
		result hasErrors ifTrue: [ ^ 'run-test-error' ].	
		result hasFailures ifTrue: [ ^ 'run-test-failure' ].	
		result hasEffectivePassed ifTrue: [ ^ 'run-test-passed' ] ].	
		
	^ 'test-not-run'
]

{ #category : 'accessing' }
PulsarTestSuite >> toggleAllSelection [

	self isSelected
		ifTrue: [ self deselectAll ]
		ifFalse: [ self selectAll ]
]
