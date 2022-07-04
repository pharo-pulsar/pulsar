Class {
	#name : #PvPerspective,
	#superclass : #PvPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#category : #'Perspective-View'
}

{ #category : #default }
PvPerspective class >> defaultEnvironment [

	^ PvSystemEnvironment new
]

{ #category : #'instance creation' }
PvPerspective class >> new [

	^ self on: (PvEnvironmentModel newEntity: self defaultEnvironment)
]

{ #category : #'instance creation' }
PvPerspective class >> newApplication: anApplication [

	^ self 
		newApplication: anApplication
		model: (PvEnvironmentModel newEntity: self defaultEnvironment)
]

{ #category : #'private - windows' }
PvPerspective >> addPresenter: aPresenter toContainer: aContainer [
	
	aContainer addWindow: aPresenter
]

{ #category : #'accessing - windows' }
PvPerspective >> addWindow: aPresenter [

	^ self 
		addWindow: aPresenter 
		atContainerNamed: aPresenter containerName
]

{ #category : #'private - windows' }
PvPerspective >> addWindow: aPresenter atContainerNamed: aName [

	self 
		containerNamed: aName
		ifPresent: [ :aContainer | self addPresenter: aPresenter toContainer: aContainer ] 
		ifAbsent: [ 
			aPresenter 
				application: self application;
				open ].
	
	aPresenter perspective: self
]

{ #category : #'private - windows' }
PvPerspective >> addWindow: aPresenter atContainerNamed: aName ifAbsent: absentBlock [

	aName ifNil: [ 
		absentBlock value. 
		^ self ].

	self 
		containerNamed: aName
		ifPresent: [ :aContainer | aContainer addWindow: aPresenter ] 
		ifAbsent: absentBlock
]

{ #category : #'accessing - windows' }
PvPerspective >> addWindow: aPresenter ifContainerAbsent: aBlock [

	^ self 
		addWindow: aPresenter 
		atContainerNamed: aPresenter containerName
		ifAbsent: aBlock
]

{ #category : #private }
PvPerspective >> containerNamed: aName ifPresent: presentBlock ifAbsent: absentBlock [

	^ self layout allPresenters
		detect: [ :each | each name = aName ] 
		ifFound: presentBlock
		ifNone: absentBlock
]

{ #category : #initialization }
PvPerspective >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 1200@900
]

{ #category : #testing }
PvPerspective >> isFloatingWindow [

	^ true
]

{ #category : #private }
PvPerspective >> newContainer: aName [

	^ (self instantiate: PvContainerPresenter)
		name: aName;
		yourself
]

{ #category : #private }
PvPerspective >> newEditorContainer: aName [

	^ (self instantiate: PvEditorContainerPresenter)
		name: aName;
		yourself
]

{ #category : #removing }
PvPerspective >> removeWindow: aContainerPresenter [ 
	
	self flag: #TODO.
	self halt.
]

{ #category : #'accessing - navigation' }
PvPerspective >> selectClass: aClass [

	self subclassResponsibility
]
