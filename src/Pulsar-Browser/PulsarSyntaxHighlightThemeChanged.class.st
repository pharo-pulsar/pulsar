Class {
	#name : 'PulsarSyntaxHighlightThemeChanged',
	#superclass : 'Announcement',
	#instVars : [
		'newTheme',
		'oldTheme'
	],
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'accessing' }
PulsarSyntaxHighlightThemeChanged >> newTheme [

	^ newTheme
]

{ #category : 'accessing' }
PulsarSyntaxHighlightThemeChanged >> newTheme: aString [

	newTheme := aString
]

{ #category : 'accessing' }
PulsarSyntaxHighlightThemeChanged >> oldTheme [

	^ oldTheme
]

{ #category : 'accessing' }
PulsarSyntaxHighlightThemeChanged >> oldTheme: aString [

	oldTheme := aString
]
