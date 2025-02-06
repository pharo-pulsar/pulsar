Class {
	#name : 'PvMethodDecorator',
	#superclass : 'Object',
	#instVars : [
		'model'
	],
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvMethodDecorator class >> allApplyingTo: aModel [
	
	"avoid a copy since I know I will not modify it"
	^ self basicSubclasses
		select: [ :each | each appliesTo: aModel entity ]
		thenCollect: [ :each | each on: aModel ]
]

{ #category : 'testing' }
PvMethodDecorator class >> appliesTo: aMethod [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
PvMethodDecorator class >> on: aModel [

	^  self new
		model: aModel;
		yourself
]

{ #category : 'accessing' }
PvMethodDecorator >> colorName [

	^ nil
]

{ #category : 'accessing' }
PvMethodDecorator >> iconName [

	^ nil
]

{ #category : 'accessing' }
PvMethodDecorator >> model [

	^ model
]

{ #category : 'accessing' }
PvMethodDecorator >> model: aModel [

	model := aModel
]
