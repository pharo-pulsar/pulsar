Class {
	#name : #StBrowserMethodDecorator,
	#superclass : #Object,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'NewTools-Browser-Model-Method'
}

{ #category : #accessing }
StBrowserMethodDecorator class >> allApplingTo: aMethod [

	^ self subclasses 
		select: [ :each | each appliesTo: aMethod ]
		thenCollect: [ :each | each uniqueInstance ]
]

{ #category : #testing }
StBrowserMethodDecorator class >> appliesTo: aMethod [

	^ false
]

{ #category : #'instance creation' }
StBrowserMethodDecorator class >> new [

	self error: 'Use #uniqueInstance'
]

{ #category : #'instance creation' }
StBrowserMethodDecorator class >> uniqueInstance [

	self = StBrowserMethodDecorator 
		ifTrue: [ ^ self error: 'I''m an abstract class, use one of my children instead.' ].
	^ uniqueInstance ifNil: [ uniqueInstance := super new ]
]

{ #category : #accessing }
StBrowserMethodDecorator >> iconName [

	^ nil
]
