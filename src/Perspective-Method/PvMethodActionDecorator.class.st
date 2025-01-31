Class {
	#name : 'PvMethodActionDecorator',
	#superclass : 'PvAction',
	#instVars : [
		'presenterClass'
	],
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvMethodActionDecorator class >> allApplyingTo: aMethod [
	
	"avoid a copy since I know I will not modify it"
	^ self basicSubclasses
		select: [ :each | each appliesTo: aMethod ]
		thenCollect: [ :each | each new ]
]

{ #category : 'testing' }
PvMethodActionDecorator class >> appliesTo: aMethod [

	^ self subclassResponsibility
]

{ #category : 'converting' }
PvMethodActionDecorator >> asSpecCommand [

	^ super asSpecCommand
		in: [ :this | 
			self presenterClass ifNotNil: [ :aClass |
				this buildPresenterBlock: [ aClass on: self ] ] ];
		yourself
]

{ #category : 'accessing' }
PvMethodActionDecorator >> presenterClass [

	^ presenterClass
]

{ #category : 'accessing' }
PvMethodActionDecorator >> presenterClass: aPresenterClass [

	presenterClass := aPresenterClass
]
