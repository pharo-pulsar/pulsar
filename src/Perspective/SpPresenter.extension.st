Extension { #name : #SpPresenter }

{ #category : #'*Perspective' }
SpPresenter >> isEditor [
	
	^ false
]

{ #category : #'*Perspective' }
SpPresenter >> isPerspective [

	^ false
]

{ #category : #'*Perspective' }
SpPresenter >> isView [

	^ false
]

{ #category : #'*Perspective' }
SpPresenter >> perspective [
	"as 'root', but answers the perspective"
	self isPerspective ifTrue: [ ^ self ].
	self hasOwner ifTrue: [ ^ self owner perspective ].
	^ nil
]

{ #category : #'*Perspective' }
SpPresenter >> systemNavigation [

	self withPerspectiveDo: [ :perspective | ^ perspective systemNavigation ].
	^ super systemNavigation
]

{ #category : #'*Perspective' }
SpPresenter >> view [
	"as 'root', but answers the perspective view"
	self isView ifTrue: [ ^ self ].
	self hasOwner ifTrue: [ ^ self owner view ].
	^ nil
]

{ #category : #'*Perspective' }
SpPresenter >> withPerspectiveDo: aBlock [

	self perspective ifNotNil: aBlock
]

{ #category : #'*Perspective' }
SpPresenter >> withViewDo: aBlock [

	self view ifNotNil: aBlock
]
