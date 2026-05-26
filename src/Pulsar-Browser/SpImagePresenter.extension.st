Extension { #name : 'SpImagePresenter' }

{ #category : '*Pulsar-Browser' }
SpImagePresenter >> pulsarThemeChanged [

	self image ifNotNil: [ :anImage | self image: anImage ]
]
