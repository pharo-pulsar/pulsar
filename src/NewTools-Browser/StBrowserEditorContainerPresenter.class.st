Class {
	#name : #StBrowserEditorContainerPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'editors',
		'editorNotebook'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StBrowserEditorContainerPresenter >> basicPushEditor: anEditor [

	editors add: anEditor.
	anEditor addToNotebook: editorNotebook 
]

{ #category : #accessing }
StBrowserEditorContainerPresenter >> editors [

	^ editors
]

{ #category : #initialization }
StBrowserEditorContainerPresenter >> initialize [

	editors := OrderedCollection new.
	super initialize.
]

{ #category : #initialization }
StBrowserEditorContainerPresenter >> initializePresenters [ 

	self layout: (SpBoxLayout newTopToBottom
		add: (editorNotebook := self newNotebook);
		yourself)
]

{ #category : #accessing }
StBrowserEditorContainerPresenter >> pushEditor: anEditor [

	editors withIndexDo: [ :eachEditor :index |
		(eachEditor isSameAs: anEditor) ifTrue: [ | page |
			eachEditor replaceWith: anEditor.
			page := editorNotebook pageAt: index.
			eachEditor updateNotebookPage: page. 
			editorNotebook selectPage: page.
			^ self ] ].

	self basicPushEditor: anEditor.
	editorNotebook selectPageIndex: editors size
]

{ #category : #accessing }
StBrowserEditorContainerPresenter >> pushEditors: aCollection [
	
	self application defer: [
		aCollection do: [ :each | self pushEditor: each ] ]
]

{ #category : #accessing }
StBrowserEditorContainerPresenter >> removeEditorsMatching: aBlock [
	| toRemove |

	toRemove := self editors select: aBlock.
	toRemove ifEmpty: [ ^ self ].
	(editorNotebook pages 
		select: [ :each | toRemove includes: each activePresenter ])
		do: [ :each | editorNotebook removePage: each ].
	editors removeAll: toRemove
]
