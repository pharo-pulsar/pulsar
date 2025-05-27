Extension { #name : 'SpPanelWidgetPresenter' }

{ #category : '*Perspective' }
SpPanelWidgetPresenter >> systemNavigation [

	^ super systemNavigation
		responderPresenter: self presenter;
		yourself
]
