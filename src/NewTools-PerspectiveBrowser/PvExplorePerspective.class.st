Class {
	#name : #PvExplorePerspective,
	#superclass : #PvPerspective,
	#category : #'NewTools-PerspectiveBrowser-View'
}

{ #category : #initialization }
PvExplorePerspective >> defaultLayout [

	^ SpPanedLayout newLeftToRight 
		positionOfSlider: 30 percent;
		first: (self newContainer: #overview) useHorizontalLayout;
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
	self addWindow: (PvPackagesListPresenter on: self model).
	

]

{ #category : #initialization }
PvExplorePerspective >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Pharo Explorer'
]

{ #category : #'as yet unclassified' }
PvExplorePerspective >> itemActivated: ann [
	self halt.
]

{ #category : #'as yet unclassified' }
PvExplorePerspective >> itemSelected: aModel [

]

{ #category : #initialization }
PvExplorePerspective >> subscribeToAnnouncements [

	self announcer 
		when: PvSelectedAnnouncement send: #itemSelected: to: self;
		when: PvActivatedAnnouncement send: #itemActivated: to: self.
]
