Class {
	#name : #PvPerspectiveBrowser,
	#superclass : #LnContainerPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#category : #'Perspective-View-Perspective'
}

{ #category : #default }
PvPerspectiveBrowser class >> defaultEnvironment [

	^ PvSystemEnvironment new
]

{ #category : #'instance creation' }
PvPerspectiveBrowser class >> new [

	^ self on: (PvEnvironmentModel newEntity: self defaultEnvironment)
]

{ #category : #'instance creation' }
PvPerspectiveBrowser class >> newApplication: anApplication [

	^ self 
		newApplication: anApplication
		model: (PvEnvironmentModel newEntity: self defaultEnvironment)
]

{ #category : #'private - windows' }
PvPerspectiveBrowser >> addPresenter: aPresenter toContainer: aContainer [
	
	aContainer addWindow: aPresenter
]

{ #category : #'accessing - windows' }
PvPerspectiveBrowser >> addWindow: aPresenter [

	^ self 
		addWindow: aPresenter 
		atContainerNamed: aPresenter containerName
]

{ #category : #'private - windows' }
PvPerspectiveBrowser >> addWindow: aPresenter atContainerNamed: aName [

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
PvPerspectiveBrowser >> addWindow: aPresenter atContainerNamed: aName ifAbsent: absentBlock [

	aName ifNil: [ 
		absentBlock value. 
		^ self ].

	self 
		containerNamed: aName
		ifPresent: [ :aContainer | aContainer addWindow: aPresenter ] 
		ifAbsent: absentBlock
]

{ #category : #'private - windows' }
PvPerspectiveBrowser >> addWindow: aPresenter ifContainerAbsent: aBlock [

	^ self 
		addWindow: aPresenter 
		atContainerNamed: aPresenter containerName
		ifAbsent: aBlock
]

{ #category : #actions }
PvPerspectiveBrowser >> close [
	
	self withWindowDo: [ :window | window close ]
]

{ #category : #private }
PvPerspectiveBrowser >> containerNamed: aName ifPresent: presentBlock ifAbsent: absentBlock [

	^ self layout allPresenters
		detect: [ :each | each name = aName ] 
		ifFound: presentBlock
		ifNone: absentBlock
]

{ #category : #accessing }
PvPerspectiveBrowser >> contentPresenters [

	^ (self presenters
		select: [ :each | (each ~= self) and:[ each isContainer ] ])
		flatCollect: [ :each | each contentPresenters ]
]

{ #category : #'private - settings' }
PvPerspectiveBrowser >> globalShortcuts [

	^ "super globalShortcuts,"
	  (self settings shortcutsFor: #perspective),
	  (self settings shortcutsFor: #window)
]

{ #category : #initialization }
PvPerspectiveBrowser >> initialize [

	super initialize.
	self subscribeToAnnouncements
]

{ #category : #initialization }
PvPerspectiveBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self title;
		initialExtent: 1200@750.
	self addGlobalShortcutsTo: aWindowPresenter		
]

{ #category : #testing }
PvPerspectiveBrowser >> isFloatingWindow [

	^ true
]

{ #category : #factory }
PvPerspectiveBrowser >> newContainer: aName [

	^ (self instantiate: PvContainerPresenter)
		name: aName;
		yourself
]

{ #category : #factory }
PvPerspectiveBrowser >> newEditorContainer: aName [

	^ (self instantiate: PvEditorContainerPresenter)
		name: aName;
		yourself
]

{ #category : #'events - handling' }
PvPerspectiveBrowser >> resendToPresenters: ann [

	self presenters 
		do: [ :each | each announcer announce: ann ]
]

{ #category : #initialization }
PvPerspectiveBrowser >> subscribeToAnnouncements [

	self announcer 
		when: PvSelectedAnnouncement send: #resendToPresenters: to: self;
		when: PvActivatedAnnouncement send: #resendToPresenters: to: self;
		when: PvChangedAnnouncement send: #resendToPresenters: to: self
]

{ #category : #initialization }
PvPerspectiveBrowser >> title [
		
	self flag: #TODO.
	^ 'Browser'
]

{ #category : #initialization }
PvPerspectiveBrowser >> usePerspectiveLayout: aLayoutClass [

	tileLayout := aLayoutClass activateOn: self
]
