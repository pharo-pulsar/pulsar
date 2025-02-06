Class {
	#name : 'PvMethodActionDecorator',
	#superclass : 'PvAction',
	#instVars : [
		'model',
		'presenterClass'
	],
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvMethodActionDecorator class >> allApplyingTo: aModel [
	
	"avoid a copy since I know I will not modify it"
	^ self basicSubclasses
		select: [ :each | each appliesTo: aModel entity ]
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
				this buildPresenterBlock: [ :aCommand | 
						self context 
							instantiate: aClass 
							on: aCommand ] ] ];
		yourself
]

{ #category : 'accessing' }
PvMethodActionDecorator >> model [

	^ model
]

{ #category : 'accessing' }
PvMethodActionDecorator >> model: aModel [

	model := aModel
]

{ #category : 'accessing' }
PvMethodActionDecorator >> presenterClass [

	^ presenterClass
]

{ #category : 'accessing' }
PvMethodActionDecorator >> presenterClass: aPresenterClass [

	presenterClass := aPresenterClass
]
