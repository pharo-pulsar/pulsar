"
A set of editors to be associated with a selection.
It contains editors and properties qualifying them (for example, which one is the default).

It is meant to be answered in `StBaseModel>>#associatedEditors`, and it is a throwaway object (it is to be used once and then dispose it).
"
Class {
	#name : #StBrowserAssociatedEditorSet,
	#superclass : #Object,
	#instVars : [
		'editors',
		'default'
	],
	#category : #'NewTools-Browser-Model'
}

{ #category : #'instance creation' }
StBrowserAssociatedEditorSet class >> with: anEditor [

	^ self new 
		add: anEditor;
		yourself
]

{ #category : #accessing }
StBrowserAssociatedEditorSet >> add: anEditor [ 

	editors add: anEditor
]

{ #category : #accessing }
StBrowserAssociatedEditorSet >> addDefault: anEditor [ 

	self add: anEditor.
	self default: anEditor
]

{ #category : #accessing }
StBrowserAssociatedEditorSet >> default [

	^ default ifNil: [ editors last ]
]

{ #category : #accessing }
StBrowserAssociatedEditorSet >> default: anEditor [

	default := anEditor
]

{ #category : #accessing }
StBrowserAssociatedEditorSet >> defaultIndex [

	editors ifEmpty: [ ^ nil ].
	^ editors indexOf: self default
]

{ #category : #accessing }
StBrowserAssociatedEditorSet >> editors [

	^ editors
]

{ #category : #initialization }
StBrowserAssociatedEditorSet >> initialize [

	super initialize.
	editors := OrderedCollection new: 5
]
