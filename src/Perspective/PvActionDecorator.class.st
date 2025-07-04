Class {
	#name : 'PvActionDecorator',
	#superclass : 'PvAction',
	#instVars : [
		'model',
		'presenterClass'
	],
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'converting' }
PvActionDecorator >> asSpecCommand [

	^ super asSpecCommand
		in: [ :this | 
			self presenterClass ifNotNil: [ :aClass |
				this buildPresenterBlock: [ :aCommand | 
						self context 
							instantiate: aClass 
							on: aCommand ] ] ];
		yourself
]

{ #category : 'accessing - runtime' }
PvActionDecorator >> model [

	^ model
]

{ #category : 'accessing' }
PvActionDecorator >> model: aModel [

	model := aModel
]

{ #category : 'accessing' }
PvActionDecorator >> presenterClass [

	^ presenterClass
]

{ #category : 'accessing' }
PvActionDecorator >> presenterClass: aPresenterClass [

	presenterClass := aPresenterClass
]
