Extension { #name : 'SpToolbarButtonPresenter' }

{ #category : '*Pulsar-Browser' }
SpToolbarButtonPresenter >> pulsarThemeChanged [

	self icon ifNotNil: [ :anIcon | self icon: anIcon ]
]
