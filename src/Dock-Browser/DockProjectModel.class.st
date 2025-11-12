Class {
	#name : 'DockProjectModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'baselineClass',
		'repositoryModel'
	],
	#category : 'Dock-Browser-View-Project',
	#package : 'Dock-Browser',
	#tag : 'View-Project'
}

{ #category : 'instance creation' }
DockProjectModel class >> newEntity: anObject environment: anEnvironmentModel [

	^ self basicNew 
		entity: anObject;
		environmentModel: anEnvironmentModel;
		initialize;
		yourself
]

{ #category : 'visiting' }
DockProjectModel >> accept: aVisitor [

	^ aVisitor visitProjectModel: self
]

{ #category : 'accessing' }
DockProjectModel >> addPackageNamed: aName [

	self flag: #TODO. "What to do here? Throw an error?"
	(self environmentModel hasPackageNamed: aName) 
		ifTrue: [ ^ self ].
		
	self environmentModel addPackageNamed: aName.
	self flag: #TODO. "I need to add it to the project! (the baseline)"
]

{ #category : 'converting' }
DockProjectModel >> asClassModel [

	^ PvClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : 'converting' }
DockProjectModel >> asOutlineClassModel [

	^ PvOutlineClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : 'accessing' }
DockProjectModel >> baselineClassModel [

	^ PvClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : 'accessing' }
DockProjectModel >> children [

	^ Array streamContents: [ :stream |
		stream nextPutAll: self collectPackageModels.
		self entity new project version projects do: [ :each |
			self class environment 
				at: each className asSymbol
				ifPresent: [ :aBaselineClass |
					stream nextPut: (PvTreeNodeModel
						newName: each name 
						iconName: 'project'
						children: (self collectPackageModelsOn: aBaselineClass)) ] ] ]
]

{ #category : 'accessing' }
DockProjectModel >> collectPackageModels [

	^ self collectPackageModelsOn: self entity
]

{ #category : 'private' }
DockProjectModel >> collectPackageModelsOn: aBaselineClass [
	| specs | 
	
	"This does not resist demeters law, badly"
	specs := aBaselineClass new project version packages.
	^ (specs 
		select: [ :each | self environmentModel hasPackageNamed: each name ]
		thenCollect: [ :each | 
			PvPackageModel 
				newEnvironment: self environmentModel
				parent: self
				entity: (self environmentModel packageNamed: each name) ])
		sorted: #name ascending
]

{ #category : 'accessing' }
DockProjectModel >> dependencesEnvironment [
	| dict |

	dict := SystemDictionary new.
	self flag: #TODO. "This is kind of horrible, but well..."
	self entity new project version projects do: [ :eachProject |  
		eachProject className ifNotNil: [ :aName |
			(self packagesOn: (self class environment classNamed: aName)) 
				do: [ :eachPackage | 
					eachPackage definedClasses do: [ :each | dict at: each name put: each ] ] ] ].
	^ dict
]

{ #category : 'accessing' }
DockProjectModel >> dependencyModels [
	| version |

	version := self entity project version.
	^ version packages, 
		version groups, 
		version projects
]

{ #category : 'private' }
DockProjectModel >> detectRepository [

	^ IceRepository registry 
		detect: [ :each | each includesPackageNamed: self entity name ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
DockProjectModel >> dockEditorClass [

	^ DockProjectEditor
]

{ #category : 'accessing' }
DockProjectModel >> editorClass [

	^ PvProjectEditorView
]

{ #category : 'accessing' }
DockProjectModel >> fullName [
	
	^  self name
]

{ #category : 'accessing' }
DockProjectModel >> iconName [

	^ 'project'
]

{ #category : 'testing' }
DockProjectModel >> isManagedAndModified [ 
	"Answer if this project is 'managed' in iceberg"

	^ self repositoryModel
		ifNotNil: [ :aRepository | aRepository workingCopy isModified ]
		ifNil: [ false ]
]

{ #category : 'testing' }
DockProjectModel >> isProject [

	^ true
]

{ #category : 'accessing' }
DockProjectModel >> name [

	self entity ifNil: [ ^ 'None' ].
	^ self entity name allButFirst: 10 "BaselineOf"
]

{ #category : 'private' }
DockProjectModel >> packagesOn: aBaselineClass [
	| specs | 
	
	"This does not resist demeters law, badly"
	specs := aBaselineClass new project version packages.
	^ (specs 
		select: [ :each | self environmentModel hasPackageNamed: each name ]
		thenCollect: [ :each | self environmentModel packageNamed: each name ])
		sorted: #name ascending
]

{ #category : 'accessing' }
DockProjectModel >> projectEnvironment [
	| dict |

	dict := SystemEnvironment new.
	(self packagesOn: self entity) 
		do: [ :eachPackage | 
			eachPackage definedClasses do: [ :each | dict at: each name put: each ] ].
	^ dict
]

{ #category : 'accessing' }
DockProjectModel >> repositoryModel [

	^ repositoryModel ifNil: [ repositoryModel := self detectRepository ]
]

{ #category : 'accessing' }
DockProjectModel >> systemEnvironment [

	^ self class environment
]
