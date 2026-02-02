Class {
	#name : 'PulsarMultiProjectModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'projectModels'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'instance creation' }
PulsarMultiProjectModel class >> newEnvironment: anEnvironmentModel [

	^ self newEnvironment: anEnvironmentModel entity: nil
]

{ #category : 'visiting' }
PulsarMultiProjectModel >> accept: aVisitor [

	^ aVisitor visitProjectModel: aVisitor
]

{ #category : 'actions' }
PulsarMultiProjectModel >> addProject: aBaselineClass [
	| newProjectModel |

	newProjectModel := (PulsarProjectModel 
		newEntity: aBaselineClass 
		environment: self environmentModel).
	
	(projectModels includes: newProjectModel) ifTrue: [ ^ self ].
	
	projectModels := projectModels copyWith: newProjectModel
]

{ #category : 'private' }
PulsarMultiProjectModel >> allBaselines [
	"used for opening projects"
		
	^ self environmentModel allBaselines sorted: #name ascending
]

{ #category : 'accessing' }
PulsarMultiProjectModel >> allChildren [

	^ self children copyWith: self environmentModel
]

{ #category : 'accessing' }
PulsarMultiProjectModel >> children [

	^ projectModels
]

{ #category : 'accessing' }
PulsarMultiProjectModel >> findPathForClass: aClass [
	
	^ self findPathForClassModel: (PvClassModel 
		newEnvironment: self environmentModel 
		entity: aClass)
]

{ #category : 'accessing' }
PulsarMultiProjectModel >> findPathForClassModel: aClassModel [
	| path |
	
	self allChildren withIndexDo: [ :each :index |
		path := self 
			pathTo: { aClassModel packageName. aClassModel packageTagName }
			in: each children.
		path ifNotEmpty: [
			^ { index }, 
			  (path collect: #value), 
			  (self 
					findRecursivelyPathForClassModel: aClassModel 
					inNode: path last key) ] ].
	^ nil
]

{ #category : 'accessing' }
PulsarMultiProjectModel >> findPathForPackage: aPackage [
	| path |
	
	self allChildren withIndexDo: [ :each :index |
		path := self 
			pathTo: { aPackage name }
			in: each children.
		path ifNotEmpty: [ ^ { index }, (path collect: #value) ] ].
	
	^ nil
]

{ #category : 'private' }
PulsarMultiProjectModel >> findRecursivelyPathForClassModel: aClassModel inNode: aNode [
	"finds a subpath for a class model starting in a node. This is like this 
	 because after the tag, the structure will be a tree of nodes (because this 
	 is organised hierarchicaly)"
	
	aNode children withIndexDo: [ :each :index | 
		each realModel = aClassModel 
			ifTrue: [ ^ { index } ].
		(self findRecursivelyPathForClassModel: aClassModel inNode: each)
			ifNotEmpty: [ :subPath | ^ { index }, subPath ] ].
		
	^ #()
]

{ #category : 'initialization' }
PulsarMultiProjectModel >> initialize [

	super initialize.
	projectModels := #()
]

{ #category : 'accessing' }
PulsarMultiProjectModel >> name [

	^ 'Projects'
]

{ #category : 'actions' }
PulsarMultiProjectModel >> newProjectNamed: aName [

	| baselineName baselineClass |
	self flag: #TODO. "I am missing validations, handling of errors, etc" 

	baselineName := ('BaselineOf', aName) asSymbol.
	baselineClass := BaselineOf << baselineName
		package: baselineName;
		install.

	baselineClass 
		compile: 'baseline: spec
	<baseline>

	spec for: #common do: [
	]'
		classified: 'baselines'.
		
	^ baselineClass
]

{ #category : 'private' }
PulsarMultiProjectModel >> pathTo: aPath in: aCollection [
	| segment |

	aPath ifEmpty: [ ^ #() ].

	segment := aPath first.
	aCollection withIndexDo: [ :each :index |
		each name = segment ifTrue: [ 
			^ { each -> index }, (self pathTo: aPath allButFirst in: each children ) ] ].

	^ #()
]

{ #category : 'actions' }
PulsarMultiProjectModel >> removeProjectModel: aModel [

	projectModels := projectModels copyWithout: aModel
]
