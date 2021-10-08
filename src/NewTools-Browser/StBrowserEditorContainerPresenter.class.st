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
StBrowserEditorContainerPresenter >> activeEditor [
	
	^ editorNotebook selectedPage activePresenter
]

{ #category : #'private - pushing' }
StBrowserEditorContainerPresenter >> adoptEditor: anEditor intoEditor: currentEditor fromPage: index [
	| page |
	
	currentEditor replaceWith: anEditor.
	page := editorNotebook pageAt: index.
	currentEditor updateNotebookPage: page

]

{ #category : #'private - pushing' }
StBrowserEditorContainerPresenter >> basicPushEditor: anEditor [

	editors add: anEditor.
	anEditor addToNotebook: editorNotebook 
]

{ #category : #accessing }
StBrowserEditorContainerPresenter >> editors [

	^ editors
]

{ #category : #testing }
StBrowserEditorContainerPresenter >> hasEditorSuchAs: aBlock [

	^ self editors anySatisfy: aBlock
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

{ #category : #'accessing - pushing' }
StBrowserEditorContainerPresenter >> pushAssociatedEditors: anAssociatedEditorSet [

	self application defer: [
		anAssociatedEditorSet editors
			do: [ :each | 
				self 
					pushEditor: each
					then: [ :aPage | 
						anAssociatedEditorSet default = each 
							ifTrue: [ editorNotebook selectPage: aPage ] ] ] ]	
]

{ #category : #'private - pushing' }
StBrowserEditorContainerPresenter >> pushEditor: anEditor [

	editors withIndexDo: [ :eachEditor :index |
		(eachEditor isSameAs: anEditor) ifTrue: [ 
			^ self 
				adoptEditor: anEditor 
				intoEditor: eachEditor
				fromPage: index ] ].

	self basicPushEditor: anEditor.
	editorNotebook selectPageIndex: editors size
]

{ #category : #'private - pushing' }
StBrowserEditorContainerPresenter >> pushEditor: anEditor then: aBlock [

	editors withIndexDo: [ :eachEditor :index |
		(eachEditor isSameAs: anEditor) ifTrue: [ 
			| page |
			page := editorNotebook pageAt: index.
			eachEditor replaceWith: anEditor.
			eachEditor updateNotebookPage: page.
			aBlock value: page.
			^ self ] ].

	self basicPushEditor: anEditor.
	aBlock value: editorNotebook pages last
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
