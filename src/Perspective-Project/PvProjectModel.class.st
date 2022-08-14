Class {
	#name : #PvProjectModel,
	#superclass : #PvEntityModel,
	#instVars : [
		'baselineClass'
	],
	#category : #'Perspective-Project-Model'
}

{ #category : #'instance creation' }
PvProjectModel class >> newEntity: anObject environment: anEnvironmentModel [

	^ self basicNew 
		entity: anObject;
		environmentModel: anEnvironmentModel;
		initialize;
		yourself
]

{ #category : #accessing }
PvProjectModel >> children [

	^ Array streamContents: [ :stream |
		stream nextPutAll: self collectPackageModels.
		self entity new project version projects do: [ :each |
			self class environment 
				at: each className asSymbol
				ifPresent: [ :aBaselineClass |
					stream nextPut: (PvEntityTreeNode
						newName: each name 
						iconName: 'project'
						children: (self collectPackageModelsOn: aBaselineClass)) ] ].
		stream nextPut: self environmentModel ]
]

{ #category : #accessing }
PvProjectModel >> collectPackageModels [

	^ self collectPackageModelsOn: self entity
]

{ #category : #private }
PvProjectModel >> collectPackageModelsOn: aBaselineClass [
	| specs | 
	
	"This does not resist demeters law, badly"
	specs := aBaselineClass new project version packages.
	^ (specs 
		select: [ :each | self environmentModel hasPackageNamed: each name ]
		thenCollect: [ :each | self environmentModel packageModelNamed: each name ])
		sorted: #name ascending
]

{ #category : #accessing }
PvProjectModel >> dependencesEnvironment [
	| dict |

	dict := SystemDictionary new.
	self entity new project version projects do: [ :eachProject |  
		(self packagesOn: eachProject projectClass) 
			do: [ :eachPackage | 
				eachPackage definedClasses do: [ :each | dict at: each name put: each ] ] ].
	^ dict
]

{ #category : #accessing }
PvProjectModel >> iconName [

	^ 'project'
]

{ #category : #accessing }
PvProjectModel >> name [

	self entity ifNil: [ ^ 'None' ].
	^ self entity name allButFirst: 10 "BaselineOf"
]

{ #category : #private }
PvProjectModel >> packagesOn: aBaselineClass [
	| specs | 
	
	"This does not resist demeters law, badly"
	specs := aBaselineClass new project version packages.
	^ (specs 
		select: [ :each | self environmentModel hasPackageNamed: each name ]
		thenCollect: [ :each | self environmentModel packageNamed: each name ])
		sorted: #name ascending
]

{ #category : #accessing }
PvProjectModel >> projectEnvironment [
	| dict |

	dict := SystemDictionary new.
	(self packagesOn: self entity) 
		do: [ :eachPackage | 
			eachPackage definedClasses do: [ :each | dict at: each name put: each ] ].
	^ dict
]

{ #category : #accessing }
PvProjectModel >> systemEnvironment [

	^ self class environment
]
