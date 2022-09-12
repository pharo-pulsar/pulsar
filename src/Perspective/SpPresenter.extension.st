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
SpPresenter >> withPerspectiveDo: aBlock [

	self perspective ifNotNil: aBlock
]
