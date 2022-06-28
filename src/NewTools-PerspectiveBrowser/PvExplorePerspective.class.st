Class {
	#name : #PvExplorePerspective,
	#superclass : #PvPerspective,
	#instVars : [
		'projectPresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View'
}

{ #category : #initialization }
PvExplorePerspective >> defaultLayout [

	^ SpPanedLayout newLeftToRight 
		positionOfSlider: 30 percent;
		first: (self newContainer: #overview) useVerticalLayout;
		second: (SpPanedLayout newTopToBottom
			positionOfSlider: 70 percent;
			first: (self newEditorContainer: #edit) useTabLayout;
			second: (self newContainer: #tools) useTabLayout;
			yourself);
		yourself
		
]

{ #category : #initialization }
PvExplorePerspective >> initialize [

	super initialize.
	self subscribeToAnnouncements.
	self addWindow: (projectPresenter := PvProjectPresenter new).
	self addWindow: PvOutlinePresenter new
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

{ #category : #initialization }
PvExplorePerspective >> subscribeToAnnouncements [

	self announcer 
		when: PvSelectedAnnouncement send: #resendToPresenters: to: self;
		when: PvActivatedAnnouncement send: #resendToPresenters: to: self
]

{ #category : #visiting }
PvExplorePerspective >> visitMethodModel: aModel [

	
]
