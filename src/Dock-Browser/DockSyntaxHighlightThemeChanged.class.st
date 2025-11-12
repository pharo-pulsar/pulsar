Class {
	#name : 'DockSyntaxHighlightThemeChanged',
	#superclass : 'Announcement',
	#instVars : [
		'newTheme',
		'oldTheme'
	],
	#category : 'Dock-Browser-Announcement',
	#package : 'Dock-Browser',
	#tag : 'Announcement'
}

{ #category : 'accessing' }
DockSyntaxHighlightThemeChanged >> newTheme [

	^ newTheme
]

{ #category : 'accessing' }
DockSyntaxHighlightThemeChanged >> newTheme: aString [

	newTheme := aString
]

{ #category : 'accessing' }
DockSyntaxHighlightThemeChanged >> oldTheme [

	^ oldTheme
]

{ #category : 'accessing' }
DockSyntaxHighlightThemeChanged >> oldTheme: aString [

	oldTheme := aString
]
