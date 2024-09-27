Class {
	#name : 'PvMethodProperties',
	#superclass : 'Object',
	#instVars : [
		'method',
		'isExtension',
		'hasFlag',
		'isOverridden',
		'isOverriding'
	],
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvMethodProperties class >> on: anObject [

	^ self basicNew initialize: anObject
]

{ #category : 'testing' }
PvMethodProperties >> hasFlag [

	^ hasFlag ifNil: [ hasFlag := method hasFlag ]
]

{ #category : 'initialization' }
PvMethodProperties >> initialize: aMethod [

	self initialize.
	method := aMethod
]

{ #category : 'testing' }
PvMethodProperties >> isExtension [

	^ isExtension ifNil: [ isExtension := method isExtension ]
]

{ #category : 'testing' }
PvMethodProperties >> isOverridden [

	^ isOverridden ifNil: [ isOverridden := method isOverridden ]
]

{ #category : 'testing' }
PvMethodProperties >> isOverriding [

	^ isOverriding ifNil: [ isOverriding := method isOverriding ]
]
