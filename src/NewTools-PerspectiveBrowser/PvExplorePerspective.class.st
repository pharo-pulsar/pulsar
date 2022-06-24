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
			first: (self newContainer: #edit) useTabLayout;
			second: (self newContainer: #tools) useTabLayout;
			yourself);
		yourself
		
]

{ #category : #initialization }
PvExplorePerspective >> initialize [

	super initialize.
	self subscribeToAnnouncements.
	self addWindow: (projectPresenter := PvProjectPresenter new).
	self addWindow: PvOutlinePresenter new.
]

{ #category : #initialization }
PvExplorePerspective >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Pharo Explorer'
]

{ #category : #'events - handling' }
PvExplorePerspective >> itemActivated: ann [
]

{ #category : #'events - handling' }
PvExplorePerspective >> itemSelected: aModel [

]

{ #category : #actions }
PvExplorePerspective >> openProject: aBaselineClass [

	projectPresenter model: (PvProjectModel 
		newEntity: aBaselineClass
		environment: self model)
]

{ #category : #initialization }
PvExplorePerspective >> subscribeToAnnouncements [

	self announcer 
		when: PvSelectedAnnouncement send: #itemSelected: to: self;
		when: PvActivatedAnnouncement send: #itemActivated: to: self.
]
