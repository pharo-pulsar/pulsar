Extension { #name : 'SpAbstractButtonPresenter' }

{ #category : '*Pulsar-Browser' }
SpAbstractButtonPresenter >> pulsarThemeChanged [

	self icon ifNotNil: [ :anIcon | self icon: anIcon ]
]
