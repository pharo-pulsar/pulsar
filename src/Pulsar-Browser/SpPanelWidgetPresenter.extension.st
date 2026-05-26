Extension { #name : 'SpPanelWidgetPresenter' }

{ #category : '*Pulsar-Browser' }
SpPanelWidgetPresenter >> pulsarThemeChanged [

	self windowIcon ifNotNil: [ :anIcon | self windowIcon: anIcon ]
]
