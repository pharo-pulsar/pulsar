Class {
	#name : 'PvMethodDecorator',
	#superclass : 'Object',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvMethodDecorator class >> allApplyingTo: aMethod [
	
	"avoid a copy since I know I will not modify it"
	^ self basicSubclasses
		select: [ :each | each appliesTo: aMethod ]
		thenCollect: [ :each | each uniqueInstance ]
]

{ #category : 'testing' }
PvMethodDecorator class >> appliesTo: aMethod [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
PvMethodDecorator class >> new [

	self error: 'Use #uniqueInstance'
]

{ #category : 'instance creation' }
PvMethodDecorator class >> uniqueInstance [

	self = PvMethodDecorator 
		ifTrue: [ ^ self error: 'I''m an abstract class, use one of my children instead.' ].
	^ uniqueInstance ifNil: [ uniqueInstance := super new ]
]

{ #category : 'accessing' }
PvMethodDecorator >> colorName [

	^ nil
]

{ #category : 'accessing' }
PvMethodDecorator >> iconName [

	^ nil
]
