Class {
	#name : #StBrowseVersionsCommand,
	#superclass : #StBrowserMethodEditorCommand,
	#category : #'NewTools-Browser-Commands'
}

{ #category : #accessing }
StBrowseVersionsCommand class >> defaultDescription [

	^ 'Show versions from this method.'
]

{ #category : #accessing }
StBrowseVersionsCommand class >> defaultIconName [

	^ #history
]

{ #category : #'accessing - defaults' }
StBrowseVersionsCommand class >> defaultName [

	^ 'Versions'
]

{ #category : #accessing }
StBrowseVersionsCommand class >> priority [

	^ 100
]

{ #category : #testing }
StBrowseVersionsCommand class >> showInToolbar [

	^ true
]

{ #category : #executing }
StBrowseVersionsCommand >> execute [
	
	context doBrowseVersions
]
