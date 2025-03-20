Class {
	#name : 'PvProjectModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'baselineClass'
	],
	#category : 'Perspective-Project-Model',
	#package : 'Perspective-Project',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvProjectModel class >> newEntity: anObject environment: anEnvironmentModel [

	^ self basicNew 
		entity: anObject;
		environmentModel: anEnvironmentModel;
		initialize;
		yourself
]

{ #category : 'visiting' }
PvProjectModel >> accept: aVisitor [

	^ aVisitor visitProjectModel: self
]

{ #category : 'converting' }
PvProjectModel >> asClassModel [

	^ PvClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : 'converting' }
PvProjectModel >> asOutlineClassModel [

	^ PvOutlineClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : 'accessing' }
PvProjectModel >> baselineClassModel [

	^ PvClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : 'accessing' }
PvProjectModel >> children [

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
PvProjectModel >> collectPackageModels [

	^ self collectPackageModelsOn: self entity
]

{ #category : 'private' }
PvProjectModel >> collectPackageModelsOn: aBaselineClass [
	| specs | 
	
	"This does not resist demeters law, badly"
	specs := aBaselineClass new project version packages.
	^ (specs 
		select: [ :each | self environmentModel hasPackageNamed: each name ]
		thenCollect: [ :each | self environmentModel packageModelNamed: each name ])
		sorted: #name ascending
]

{ #category : 'accessing' }
PvProjectModel >> dependencesEnvironment [
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
PvProjectModel >> dependencyModels [
	| version |

	version := self entity project version.
	^ version packages, 
		version groups, 
		version projects
]

{ #category : 'accessing' }
PvProjectModel >> dockEditorClass [

	^ DockProjectEditor
]

{ #category : 'accessing' }
PvProjectModel >> editorClass [

	^ PvProjectEditorView
]

{ #category : 'accessing' }
PvProjectModel >> fullName [
	
	^  self name
]

{ #category : 'accessing' }
PvProjectModel >> iconName [

	^ 'project'
]

{ #category : 'testing' }
PvProjectModel >> isProject [

	^ true
]

{ #category : 'accessing' }
PvProjectModel >> name [

	self entity ifNil: [ ^ 'None' ].
	^ self entity name allButFirst: 10 "BaselineOf"
]

{ #category : 'private' }
PvProjectModel >> packagesOn: aBaselineClass [
	| specs | 
	
	"This does not resist demeters law, badly"
	specs := aBaselineClass new project version packages.
	^ (specs 
		select: [ :each | self environmentModel hasPackageNamed: each name ]
		thenCollect: [ :each | self environmentModel packageNamed: each name ])
		sorted: #name ascending
]

{ #category : 'accessing' }
PvProjectModel >> projectEnvironment [
	| dict |

	dict := SystemEnvironment new.
	(self packagesOn: self entity) 
		do: [ :eachPackage | 
			eachPackage definedClasses do: [ :each | dict at: each name put: each ] ].
	^ dict
]

{ #category : 'accessing' }
PvProjectModel >> systemEnvironment [

	^ self class environment
]
