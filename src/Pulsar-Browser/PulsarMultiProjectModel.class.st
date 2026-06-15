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

{ #category : 'actions' }
PulsarMultiProjectModel >> ensureVolatileProjectNamed: aString [
	| projectModel packageName |
	
	projectModel := PulsarVolatileProjectModel 
		newEnvironment: self environmentModel 
		entity: aString.
	
	projectModels 
		detect: [ :each | each = projectModel ] 
		ifFound: [ :existing | ^ existing ].
	
	PulsarVolatileProjectSpec 
		registerProjectNamed: aString 
		packageNames: #().
	
	projectModels := projectModels copyWith: projectModel.
	
	packageName := aString capitalized.
	
	projectModel addPackageNamed: packageName
]

{ #category : 'updating' }
PulsarMultiProjectModel >> filterWith: aString [
	
	^ (self environmentModel classesMatching: aString)
		collect: [ :each | 
			PvClassModel 
				newEnvironment: self environmentModel
				entity: each ]
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
	projectModels := #().
	super initialize.
	self initializeVolatileProjects
]

{ #category : 'initialization' }
PulsarMultiProjectModel >> initializeVolatileProjects [

	PulsarVolatileProjectSpec specs do: [ :spec |
		| projectModel |
		projectModel := PulsarVolatileProjectModel newEnvironment: self environmentModel entity: spec name.
		spec packageNames do: [ :eachPackageName |
			(self environmentModel hasPackageNamed: eachPackageName) ifTrue: [
				| packageModel |
				packageModel := PvPackageModel
		            newEnvironment: self environmentModel
		            project: projectModel
		            entity: (self environmentModel packageNamed: eachPackageName).
				projectModel packageModels add: packageModel ] ].
		projectModels := projectModels copyWith: projectModel ].
	
	"I want one Sandbox project always, so people can start to work right now"
	projectModels ifEmpty: [ 
		self ensureVolatileProjectNamed: 'Sandbox' ]
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

	aModel isVolatileProject ifTrue: [
			| packageName package |
			packageName := aModel name capitalized.
			(self environmentModel hasPackageNamed: packageName) ifTrue: [
					package := self environmentModel packageNamed: packageName.
					package definedClasses isEmpty ifTrue: [
							self environmentModel removePackageNamed: packageName.
							aModel packageModels removeAll ] ].
			PulsarVolatileProjectSpec unregisterProjectNamed: aModel name ].
	projectModels := projectModels copyWithout: aModel
]
