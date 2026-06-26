Extension { #name : 'SpCodePresenter' }

{ #category : '*Pulsar-Browser' }
SpCodePresenter >> pulsarSyntaxHighlightThemeChanged [

	self syntaxHighlightTheme: self application syntaxHighlightTheme
]

{ #category : '*Pulsar-Browser' }
SpCodePresenter >> pulsarThemeChanged [

	self styleScheme: self application styleScheme
]
