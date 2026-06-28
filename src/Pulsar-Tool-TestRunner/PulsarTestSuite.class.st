"
A test suite wrapping a TestCase subclass. Its entity is the Class.

Children are lazily-built PulsarTestCase instances, one per test selector.
"
Class {
	#name : 'PulsarTestSuite',
	#superclass : 'PvBaseModel',
	#instVars : [
		'cases'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarTestSuite >> cases [

	^ cases ifNil: [ cases := self children ]
]

{ #category : 'accessing' }
PulsarTestSuite >> children [

	cases ifNotNil: [ ^ cases ].
	cases := self entity allTestSelectors collect: [ :eachSelector |
		         PulsarTestCase newEnvironment: self environmentModel parent: self entity: (self entity selector: eachSelector) ].
	^ cases
]

{ #category : 'accessing' }
PulsarTestSuite >> description [

	^ self entity name
]

{ #category : 'selection' }
PulsarTestSuite >> deselectAll [

	self children do: [ :each | each isSelected: false ]
]

{ #category : 'accessing' }
PulsarTestSuite >> iconName [

	^ self entity systemIconName
]

{ #category : 'selection' }
PulsarTestSuite >> isSelected [
	"Return true if all cases are selected."

	^ self children allSatisfy: [ :each | each isSelected ]
]

{ #category : 'accessing' }
PulsarTestSuite >> name [

	^ self entity name
]

{ #category : 'selection' }
PulsarTestSuite >> selectAll [

	self children do: [ :each | each isSelected: true ]
]

{ #category : 'selection' }
PulsarTestSuite >> selectedCases [

	^ self children select: [ :each | each isSelected ]
]

{ #category : 'selection' }
PulsarTestSuite >> toggleAllSelection [

	self isSelected
		ifTrue: [ self deselectAll ]
		ifFalse: [ self selectAll ]
]
