Class {
	#name : #PvCopyToClipboardCommand,
	#superclass : #PvEditorCommand,
	#category : #'Perspective-Method'
}

{ #category : #accessing }
PvCopyToClipboardCommand class >> defaultDescription [

	^ 'Copy this method to clipboard.'
]

{ #category : #accessing }
PvCopyToClipboardCommand class >> defaultIconName [

	^ #smallCopy
]

{ #category : #'accessing - defaults' }
PvCopyToClipboardCommand class >> defaultName [

	^ 'Copy'
]

{ #category : #testing }
PvCopyToClipboardCommand class >> isVisibleInToolbar [

	^ true
]

{ #category : #accessing }
PvCopyToClipboardCommand class >> priority [

	^ 10
]

{ #category : #testing }
PvCopyToClipboardCommand class >> showInToolbar [

	^ true
]

{ #category : #executing }
PvCopyToClipboardCommand >> execute [
	
	context doCopyToClipboard
]
