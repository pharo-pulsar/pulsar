"
A model for a method list produced by a system query, such as senders, implementors, or references. It packages the query title, the environment, and the resulting compiled methods for `PulsarMessageBrowser`; it is not the model of a single method, and unlike the `PvBaseModel` family it has no entity of its own.

It wraps each compiled method in a `PvMethodModel`, created lazily and cached for the browser's filterable list; those wrappers provide the per-method identity, navigation, and actions. The model names `PulsarMessageBrowser` as its Pulsar editor, and its title is also its display name. A message list is a fixed result, not a live query, so the model does not follow later changes in the environment.

The normal creation path is `PulsarSystemNavigation>>browseMessageList:name:autoSelect:refreshingBlock:`, which supplies the environment, label, and query results before opening the browser. The class-side constructor builds the same model directly.

Example:
```smalltalk
PulsarMessageModel
    newEnvironment: anEnvironmentModel
    title: 'Senders of #foo'
    methods: aCollectionOfCompiledMethods
```
"
Class {
	#name : 'PulsarMessageModel',
	#superclass : 'Object',
	#traits : 'PulsarTModel + PulsarTModelEditable + PulsarTModelSnapshot',
	#classTraits : 'PulsarTModel classTrait + PulsarTModelEditable classTrait + PulsarTModelSnapshot classTrait',
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
