Class {
	#name : #PvExplorePerspective,
	#superclass : #PvPerspective,
	#instVars : [
		'projectPresenter'
	],
	#category : #'Perspective-View'
}

{ #category : #initialization }
PvExplorePerspective >> defaultLayout [

	^ SpPanedLayout newLeftToRight 
		positionOfSlider: 25 percent;
		first: (self newContainer: #overview) useVerticalLayout;
		second: (SpPanedLayout newTopToBottom
			positionOfSlider: 75 percent;
			first: (self newEditorContainer: #edit) useTabLayout;
			second: (self newContainer: #tools) useTabLayout;
			yourself);
		yourself
		
]

{ #category : #initialization }
PvExplorePerspective >> initialize [

	super initialize.
	self subscribeToAnnouncements.
	self addWindow: (projectPresenter := PvProjectView new).
	self addWindow: PvOutlineView new
]

{ #category : #initialization }
PvExplorePerspective >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Pharo Explorer'
]

{ #category : #actions }
PvExplorePerspective >> openProject: aBaselineClass [

	projectPresenter model: (PvProjectModel 
		newEntity: aBaselineClass
		environment: self model)
]

{ #category : #'events - handling' }
PvExplorePerspective >> resendToPresenters: ann [

	self presenters 
		do: [ :each | each announcer announce: ann ]
]

{ #category : #'accessing - navigation' }
PvExplorePerspective >> selectClass: aClass [
	
	self flag: #TODO.
]

{ #category : #initialization }
PvExplorePerspective >> subscribeToAnnouncements [

	self announcer 
		when: PvSelectedAnnouncement send: #resendToPresenters: to: self;
		when: PvActivatedAnnouncement send: #resendToPresenters: to: self
]
