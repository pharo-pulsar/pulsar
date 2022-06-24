Class {
	#name : #PvProjectModel,
	#superclass : #PvEntityModel,
	#instVars : [
		'baselineClass',
		'environmentModel'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Project'
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
PvProjectModel >> baselineModel [

	^ PvBaselineModel newEntity: self entity
]

{ #category : #accessing }
PvProjectModel >> children [
	
	^ self collectPackages,
	{ 
		self environmentModel 
	}
]

{ #category : #accessing }
PvProjectModel >> collectPackages [
	| specs | 
	
	"This does not resist demeters law, badly"
	specs := self entity new project version spec packageSpecsInLoadOrder.
	^ (specs 
		select: [ :each | each isPackageSpec and: [ self environmentModel hasPackageNamed: each name  ] ]
		thenCollect: [ :each | self environmentModel packageModelNamed: each name ])
		sorted: #name ascending
]

{ #category : #accessing }
PvProjectModel >> environmentModel [ 
	
	^ environmentModel
]

{ #category : #accessing }
PvProjectModel >> environmentModel: anEnvironmentModel [ 
	
	environmentModel := anEnvironmentModel
]

{ #category : #accessing }
PvProjectModel >> name [

	self entity ifNil: [ ^ 'None' ].
	^ self entity name allButFirst: 10 "BaselineOf"
]
