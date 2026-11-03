Class {
	#name : 'PulsarProjectModel',
	#superclass : 'PulsarBaseProjectModel',
	#instVars : [
		'baselineClass',
		'repositoryModel'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'instance creation' }
PulsarProjectModel class >> newEntity: anObject environment: anEnvironmentModel [

	^ self basicNew 
		entity: anObject;
		environmentModel: anEnvironmentModel;
		initialize;
		yourself
]

{ #category : 'visiting' }
PulsarProjectModel >> accept: aVisitor [

	^ aVisitor visitProjectModel: self
]

{ #category : 'converting' }
PulsarProjectModel >> asClassModel [

	^ PvClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : 'converting' }
PulsarProjectModel >> asOutlineClassModel [

	^ PvOutlineClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : 'accessing' }
PulsarProjectModel >> baselineClassModel [

	^ PvClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : 'accessing' }
PulsarProjectModel >> children [

	"honestly, I have not used in one full year the access to the dependencies, so for now I am just 
	 letting them out, until I know what to do with them."
	^ self collectPackageModels
	"^ Array streamContents: [ :stream |
		stream nextPutAll: self collectPackageModels.
		stream nextPutAll: self collectDependencyModels"
]

{ #category : 'accessing' }
PulsarProjectModel >> collectDependencyModels [

	^ Array streamContents: [ :stream |
		(self environment projectSpecsOfBaseline: self entity) do: [ :each |
			| aBaselineClass |
			aBaselineClass := self environment classNamed: each className asSymbol.
			aBaselineClass ifNotNil: [
				stream nextPut: (PvTreeNodeModel
					newModel: (PulsarProjectModel
						newEnvironment: self environmentModel
						parent: self parentModel
						entity: aBaselineClass)
					name: each name
					iconName: 'project'
					children: (self collectPackageModelsOn: aBaselineClass)) ] ] ]
]

{ #category : 'accessing' }
PulsarProjectModel >> collectPackageModels [

	^ self collectPackageModelsOn: self entity
]

{ #category : 'accessing' }
PulsarProjectModel >> collectPackageModelsOn: aBaselineClass [

	| specs |
	"This does not resist demeters law, badly"
	specs := self environment packagesOfBaseline: aBaselineClass.
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
PulsarProjectModel >> dependencesEnvironment [

	| dict |
	dict := SystemDictionary new.
	self flag: #TODO. "This is kind of horrible, but well..."
	(self environment projectSpecsOfBaseline: self entity) do: [ :eachProject |
		eachProject className ifNotNil: [ :aName |
			(self packagesOn: (self environment classNamed: aName))
				do: [ :eachPackage |
					eachPackage definedClasses do: [ :each |
						dict at: each name put: each ] ] ] ].
	^ dict
]

{ #category : 'accessing' }
PulsarProjectModel >> dependencyModels [
	| version |

	version := self entity project version.
	^ version packages, 
		version groups, 
		version projects
]

{ #category : 'accessing' }
PulsarProjectModel >> detectRepository [

	^ IceRepository registry
		detect: [ :each | each includesPackageNamed: self entity name ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
PulsarProjectModel >> fullName [
	
	^  self name
]

{ #category : 'accessing' }
PulsarProjectModel >> iconName [

	^ 'project'
]

{ #category : 'testing' }
PulsarProjectModel >> isManagedAndModified [ 
	"Answer if this project is 'managed' in iceberg"

	^ self repositoryModel
		ifNotNil: [ :aRepository | aRepository workingCopy isModified ]
		ifNil: [ false ]
]

{ #category : 'accessing' }
PulsarProjectModel >> name [

	self entity ifNil: [ ^ 'None' ].
	^ self entity name allButFirst: 10 "BaselineOf"
]

{ #category : 'accessing' }
PulsarProjectModel >> packagesOn: aBaselineClass [

	| specs |
	"This does not resist demeters law, badly"
	specs := self environment packagesOfBaseline: aBaselineClass.
	^ (specs
		select: [ :each | self environmentModel hasPackageNamed: each name ]
		thenCollect: [ :each | self environmentModel packageNamed: each name ])
		sorted: #name ascending
]

{ #category : 'accessing' }
PulsarProjectModel >> projectEnvironment [

	| dict |
	dict := SystemEnvironment new.
	(self packagesOn: self entity)
		do: [ :eachPackage |
			eachPackage definedClasses do: [ :each |
				dict at: each name put: each ] ].
	^ dict
]

{ #category : 'accessing' }
PulsarProjectModel >> repositoryModel [

	^ repositoryModel ifNil: [ repositoryModel := self detectRepository ]
]

{ #category : 'accessing' }
PulsarProjectModel >> systemEnvironment [

	^ self environment systemDictionary
]
