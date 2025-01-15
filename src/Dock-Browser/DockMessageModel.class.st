Class {
	#name : 'DockMessageModel',
	#superclass : 'Object',
	#instVars : [
		'title',
		'methods',
		'environmentModel',
		'methodModels'
	],
	#category : 'Dock-Browser-Tool-Messages',
	#package : 'Dock-Browser',
	#tag : 'Tool-Messages'
}

{ #category : 'instance creation' }
DockMessageModel class >> newEnvironment: anEnvironmentModel title: aString methods: aCollection [

	^ self new 
		environmentModel: anEnvironmentModel;
		title: aString;
		methods: aCollection;
		yourself
]

{ #category : 'accessing' }
DockMessageModel >> environmentModel [

	^ environmentModel
]

{ #category : 'accessing' }
DockMessageModel >> environmentModel: anEnvironmentModel [

	environmentModel := anEnvironmentModel
]

{ #category : 'accessing' }
DockMessageModel >> methodCount [

	^ self methods size
]

{ #category : 'accessing' }
DockMessageModel >> methodModels [

	^ methodModels ifNil: [ 
		methodModels := self methods collect: [ :each | 
			PvMethodModel 
				newEnvironment: self environmentModel
				entity: each ] ]
]

{ #category : 'accessing' }
DockMessageModel >> methods [

	^ methods
]

{ #category : 'accessing' }
DockMessageModel >> methods: aCollection [

	methods := aCollection
]

{ #category : 'accessing' }
DockMessageModel >> title [

	^ title
]

{ #category : 'accessing' }
DockMessageModel >> title: aString [

	title := aString
]
