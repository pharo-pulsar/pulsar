Class {
	#name : #PvMethodDecorator,
	#superclass : #Object,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Perspective-Method-Model'
}

{ #category : #accessing }
PvMethodDecorator class >> allApplingTo: aMethod [

	^ self subclasses 
		select: [ :each | each appliesTo: aMethod ]
		thenCollect: [ :each | each uniqueInstance ]
]

{ #category : #testing }
PvMethodDecorator class >> appliesTo: aMethod [

	^ self subclassResponsibility
]

{ #category : #'instance creation' }
PvMethodDecorator class >> new [

	self error: 'Use #uniqueInstance'
]

{ #category : #'instance creation' }
PvMethodDecorator class >> uniqueInstance [

	self = StBrowserMethodDecorator 
		ifTrue: [ ^ self error: 'I''m an abstract class, use one of my children instead.' ].
	^ uniqueInstance ifNil: [ uniqueInstance := super new ]
]

{ #category : #accessing }
PvMethodDecorator >> colorName [

	^ nil
]

{ #category : #accessing }
PvMethodDecorator >> iconName [

	^ nil
]
