Class {
	#name : #PvPerspectiveBrowser,
	#superclass : #LnContainerPresenter,
	#traits : 'SpTModel + PvTActionHolder',
	#classTraits : 'SpTModel classTrait + PvTActionHolder classTrait',
	#category : #'Perspective-View-Perspective'
}

{ #category : #default }
PvPerspectiveBrowser class >> defaultEnvironment [

	^ PvSystemEnvironment new
]

{ #category : #'as yet unclassified' }
PvPerspectiveBrowser class >> defineActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder 
		registerGroup: #perspective with: { 
			"open default tool"
			KeyboardKey enter 	shift 			-> PvShowSpotterForWindowsAction new.
			KeyboardKey enter 	ctrl 			-> PvShowSpotterForEnvironmentAction new.
			KeyboardKey enter 	alt 			-> PvShowSpotterForCommandsAction new };
		registerGroup: #window with: {
			$w mod1 								-> PvCloseCurrentWindowAction new.
		}
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

{ #category : #accessing }
PvPerspectiveBrowser >> actionGroups [

	^ #(perspective window)
]

{ #category : #activating }
PvPerspectiveBrowser >> activateClass: aClass [
	"different perspectives can have different meanings to activate a class :)"
	
	self subclassResponsibility
]

{ #category : #activating }
PvPerspectiveBrowser >> activateMethod: aMethod [
	"different perspectives can have different meanings to activate a class :)"
	
	self subclassResponsibility
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

{ #category : #'accessing - windows' }
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
	| presenter |
	
	presenter := self activePresenter.
	(presenter notNil and: [ presenter isCloseable ]) ifTrue: [
		presenter close.
		^ self ].
	self withWindowDo: [ :window | window close ]
]

{ #category : #initialization }
PvPerspectiveBrowser >> connectViews [
	"override this to connect the views of the perspective"
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

{ #category : #private }
PvPerspectiveBrowser >> editorContainer [

	^ self 
		containerNamed: #edit 
		ifPresent: [ :aContainer | aContainer ]
		ifAbsent: [ nil ]
]

{ #category : #'private - settings' }
PvPerspectiveBrowser >> globalShortcuts [

	^ self actions asKMCategory
]

{ #category : #initialization }
PvPerspectiveBrowser >> initialize [

	super initialize.
	self initializeLayout.
	self initializeViews.
	self connectViews.
	self subscribeToAnnouncements
]

{ #category : #initialization }
PvPerspectiveBrowser >> initializeLayout [
	
	self usePerspectiveLayout: self perspectiveLayoutClass
]

{ #category : #initialization }
PvPerspectiveBrowser >> initializeViews [	
	"override this to initialize the views for the perspective"
]

{ #category : #initialization }
PvPerspectiveBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self title;
		initialExtent: 1560@860.
	self addGlobalShortcutsTo: aWindowPresenter		
]

{ #category : #testing }
PvPerspectiveBrowser >> isFloatingWindow [

	^ true
]

{ #category : #testing }
PvPerspectiveBrowser >> isPerspective [

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

{ #category : #initialization }
PvPerspectiveBrowser >> perspectiveLayoutClass [

	^ self subclassResponsibility
]

{ #category : #'events - handling' }
PvPerspectiveBrowser >> resendToPresenters: ann [

	self presenters do: [ :each | each announce: ann ]
]

{ #category : #actions }
PvPerspectiveBrowser >> showSpotterForCommands [
	| spotter |
	
	self flag: #TOREMOVE.

	spotter := self 
		instantiate: PvSpotter 
		on: (PvSpotterModelForCommands newOrigin: self).
	spotter perspective: self.
	
	spotter asModalWindow
		centeredRelativeTo: self window;
		open
]

{ #category : #actions }
PvPerspectiveBrowser >> showSpotterForEnvironment [
	| spotter |
	
	self flag: #TOREMOVE.

	spotter := self 
		instantiate: PvSpotter 
		on: (PvSpotterModelForEnvironment newOrigin: self).
	spotter perspective: self.
	
	spotter asModalWindow
		centeredRelativeTo: self window;
		open
]

{ #category : #actions }
PvPerspectiveBrowser >> showSpotterForWindows [
	| spotter |
	
	self flag: #TOREMOVE.

	spotter := self 
		instantiate: PvSpotter 
		on: (PvSpotterModelForWindows newOrigin: self).
	spotter perspective: self.
	
	spotter asModalWindow
		centeredRelativeTo: self window;
		open
]

{ #category : #spotter }
PvPerspectiveBrowser >> spotterEditorsFor: aStep [
	<spotterOrder: 20 context: #windows>

	aStep listProcessor
		title: 'Editors';
		wantsToDisplayOnEmptyQuery: true;
		candidatesLimit: Float infinity;
		allCandidates: [ 
			self editorContainer allPresenters 
				select: [ :each | each isTileWindow ]
				thenCollect: [ :each | PvViewEntry on: each ] ];
		filter: StFilterSubstring
]

{ #category : #spotter }
PvPerspectiveBrowser >> spotterViewsFor: aStep [
	<spotterOrder: 10 context: #windows>

	aStep listProcessor
		title: 'Views';
		wantsToDisplayOnEmptyQuery: true;
		candidatesLimit: Float infinity;
		allCandidates: [ 
			self allPresenters
				select: [ :each | each isTileWindow and: [ each presenter isEditor not ] ]
				thenCollect: [ :each | PvViewEntry on: each ] ];
		filter: StFilterSubstring
]

{ #category : #spotter }
PvPerspectiveBrowser >> stSpotterProcessorsFor: aStep [
	"Entry point for all spotter from perspectives, I will not use the regular way to 
	 collect processors but a special mechanism with a context, to pre-filter processors"

	"normal processing"
	self spotterProcessorsFor: aStep context: aStep model context.
	"traverse containers"
	self layout allPresenters do: [ :each | 
		each spotterProcessorsFor: aStep context: aStep model context ]
]

{ #category : #initialization }
PvPerspectiveBrowser >> subscribeToAnnouncements [

	self announcer
		when: PvChangedAnnouncement 
		send: #resendToPresenters: 
		to: self
]

{ #category : #accessing }
PvPerspectiveBrowser >> systemNavigation [

	^ PvSystemNavigation newPerspective: self
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
