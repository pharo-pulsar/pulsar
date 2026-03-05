Extension { #name : 'SpPresenter' }

{ #category : '*Pulsar-Browser' }
SpPresenter >> acceptVisitor: aVisitor [

	^ aVisitor visitPresenter: self
]

{ #category : '*Pulsar-Browser' }
SpPresenter >> panelPosition [

	^ SpPanelPosition bottom
]

{ #category : '*Pulsar-Browser' }
SpPresenter >> registerToBrowser: aPulsarBrowser [
]
