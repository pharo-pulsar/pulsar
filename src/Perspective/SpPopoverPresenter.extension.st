Extension { #name : 'SpPopoverPresenter' }

{ #category : '*Perspective' }
SpPopoverPresenter >> systemNavigation [

	^ super systemNavigation
		responderPresenter: self presenter;
		yourself
]
