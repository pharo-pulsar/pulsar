Class {
	#name : 'PulsarMessageModel',
	#superclass : 'Object',
	#traits : 'PulsarTModel + PulsarTEditable + PulsarTModelSnapshot',
	#classTraits : 'PulsarTModel classTrait + PulsarTEditable classTrait + PulsarTModelSnapshot classTrait',
	#instVars : [
		'title',
		'methods',
		'environmentModel',
		'methodModels'
	],
	#category : 'Pulsar-Browser-Tool-Messages',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Messages'
}

{ #category : 'instance creation' }
PulsarMessageModel class >> newEnvironment: anEnvironmentModel title: aString methods: aCollection [

	^ self new 
		environmentModel: anEnvironmentModel;
		title: aString;
		methods: aCollection;
		yourself
]

{ #category : 'accessing' }
PulsarMessageModel >> environmentModel [

	^ environmentModel
]

{ #category : 'accessing' }
PulsarMessageModel >> environmentModel: anEnvironmentModel [

	environmentModel := anEnvironmentModel
]

{ #category : 'accessing' }
PulsarMessageModel >> fullName [

	^ self title
]

{ #category : 'accessing - ui' }
PulsarMessageModel >> iconComposite [

	^ PvCompositeIcon new 
		name: self iconName;
		yourself
]

{ #category : 'accessing - ui' }
PulsarMessageModel >> iconName [

	^ #messageBrowser
]

{ #category : 'accessing' }
PulsarMessageModel >> methodCount [

	^ self methods size
]

{ #category : 'accessing' }
PulsarMessageModel >> methodModels [

	^ methodModels ifNil: [ 
		methodModels := self methods collect: [ :each | 
			PvMethodModel 
				newEnvironment: self environmentModel
				entity: each ] ]
]

{ #category : 'accessing' }
PulsarMessageModel >> methods [

	^ methods
]

{ #category : 'accessing' }
PulsarMessageModel >> methods: aCollection [

	methods := aCollection
]

{ #category : 'accessing' }
PulsarMessageModel >> pulsarEditorClass [

	^ PulsarMessageBrowser
]

{ #category : 'accessing' }
PulsarMessageModel >> realModel [

	^ self
]

{ #category : 'accessing' }
PulsarMessageModel >> title [

	^ title
]

{ #category : 'accessing' }
PulsarMessageModel >> title: aString [

	title := aString
]
