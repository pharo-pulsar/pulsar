Class {
	#name : #PvCopyToClipboardCommand,
	#superclass : #PvEditorAction,
	#category : #'Perspective-Method-Command'
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

{ #category : #'default - groups' }
PvCopyToClipboardCommand class >> groups [

	^ #(action)
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
