Extension { #name : 'SpMenuItemPresenter' }

{ #category : '*Pulsar-Browser' }
SpMenuItemPresenter >> pulsarThemeChanged [

	self icon ifNotNil: [ :anIcon | self icon: anIcon ]
]
