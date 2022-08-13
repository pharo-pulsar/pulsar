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
		stream nextPutAll: self collectPackages.
		self entity new project version projects do: [ :each |
			self class environment 
				at: each className asSymbol
				ifPresent: [ :aBaselineClass |
					stream nextPut: (PvEntityTreeNode
						newName: each name 
						iconName: 'project'
						children: (self collectPackagesOn: aBaselineClass)) ] ].
		stream nextPut: self environmentModel ]
]

{ #category : #accessing }
PvProjectModel >> collectPackages [

	^ self collectPackagesOn: self entity
]

{ #category : #private }
PvProjectModel >> collectPackagesOn: aBaselineClass [
	| specs | 
	
	"This does not resist demeters law, badly"
	specs := aBaselineClass new project version spec packageSpecsInLoadOrder.
	^ (specs 
		select: [ :each | each isPackageSpec and: [ self environmentModel hasPackageNamed: each name  ] ]
		thenCollect: [ :each | self environmentModel packageModelNamed: each name ])
		sorted: #name ascending
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

{ #category : #accessing }
PvProjectModel >> projectEnvironment [

	^ self class environment
]
