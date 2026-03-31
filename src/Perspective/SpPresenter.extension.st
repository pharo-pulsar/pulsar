Extension { #name : 'SpPresenter' }

{ #category : '*Perspective' }
SpPresenter >> insertPopover: aPresenter [

	aPresenter asPopover
		relativeTo: self;
		popupModal
]

{ #category : '*Perspective' }
SpPresenter >> isEditor [
	
	^ false
]

{ #category : '*Perspective' }
SpPresenter >> isPerspective [

	^ false
]

{ #category : '*Perspective' }
SpPresenter >> isView [

	^ false
]

{ #category : '*Perspective' }
SpPresenter >> perspective [
	"as 'root', but answers the perspective"
	self isPerspective ifTrue: [ ^ self ].
	self hasOwner ifTrue: [ ^ self owner perspective ].
	^ nil
]

{ #category : '*Perspective' }
SpPresenter >> systemNavigation [
	"check in owner to avoid loops"
	self owner ifNotNil: [ :anOwner |
		self flag: #TODO. "I will need to remove perspective, as I am not anymore using it"
		anOwner withPerspectiveDo: [ :perspective | ^ perspective systemNavigation ].
		anOwner withNearWindowLikeDo: [ :panelWindow | ^ panelWindow systemNavigation ] ].
	
	"let application a chance to define its system navigation"
	^ self application systemNavigation
]

{ #category : '*Perspective' }
SpPresenter >> view [
	"as 'root', but answers the perspective view"
	self isView ifTrue: [ ^ self ].
	self hasOwner ifTrue: [ ^ self owner view ].
	^ nil
]

{ #category : '*Perspective' }
SpPresenter >> withPerspectiveDo: aBlock [

	self perspective ifNotNil: aBlock
]

{ #category : '*Perspective' }
SpPresenter >> withViewDo: aBlock [

	self view ifNotNil: aBlock
]
