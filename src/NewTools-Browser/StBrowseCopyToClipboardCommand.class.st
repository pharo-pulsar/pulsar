Class {
	#name : #StBrowseCopyToClipboardCommand,
	#superclass : #StBrowserMethodEditorCommand,
	#category : #'NewTools-Browser-Commands'
}

{ #category : #accessing }
StBrowseCopyToClipboardCommand class >> defaultDescription [

	^ 'Copy this method to clipboard.'
]

{ #category : #accessing }
StBrowseCopyToClipboardCommand class >> defaultIconName [

	^ #smallCopy
]

{ #category : #'accessing - defaults' }
StBrowseCopyToClipboardCommand class >> defaultName [

	^ 'Copy'
]

{ #category : #accessing }
StBrowseCopyToClipboardCommand class >> priority [

	^ 10
]

{ #category : #testing }
StBrowseCopyToClipboardCommand class >> showInToolbar [

	^ true
]

{ #category : #executing }
StBrowseCopyToClipboardCommand >> execute [
	
	context doCopyToClipboard
]
