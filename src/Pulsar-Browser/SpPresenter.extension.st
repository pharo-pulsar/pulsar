Extension { #name : 'SpPresenter' }

{ #category : '*Pulsar-Browser' }
SpPresenter >> panelPosition [

	^ SpPanelPosition bottom
]

{ #category : '*Pulsar-Browser' }
SpPresenter >> pulsarThemeChanged [
	"Called when the theme changes. Subclasses override to refresh icons."

	
]

{ #category : '*Pulsar-Browser' }
SpPresenter >> registerToBrowser: aPulsarBrowser [
]
