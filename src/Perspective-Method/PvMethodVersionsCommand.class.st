"
Open the vestions of the method contained in `context model`
"
Class {
	#name : #PvMethodVersionsCommand,
	#superclass : #PvMethodEditorCommand,
	#category : #'Perspective-Method-Commands'
}

{ #category : #accessing }
PvMethodVersionsCommand class >> defaultDescription [

	^ 'Show versions from this method.'
]

{ #category : #accessing }
PvMethodVersionsCommand class >> defaultIconName [

	^ #history
]

{ #category : #'accessing - defaults' }
PvMethodVersionsCommand class >> defaultName [

	^ 'Versions'
]

{ #category : #default }
PvMethodVersionsCommand class >> groups [

	^ #(action method)
]

{ #category : #testing }
PvMethodVersionsCommand class >> isVisibleInToolbar [

	^ true
]

{ #category : #accessing }
PvMethodVersionsCommand class >> priority [

	^ 100
]

{ #category : #testing }
PvMethodVersionsCommand class >> showInToolbar [

	^ true
]

{ #category : #executing }
PvMethodVersionsCommand >> execute [
	context systemNavigation browseVersionsOf: self model entity
]
