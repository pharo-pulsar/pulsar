Class {
	#name : #StBrowserEditorContainerPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'editorNotebook',
		'editorChangedAction'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StBrowserEditorContainerPresenter >> activeEditor [
	
	^ editorNotebook selectedPage editor
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

	anEditor addToNotebook: editorNotebook 
]

{ #category : #private }
StBrowserEditorContainerPresenter >> editorChanged: anEditor [

	editorChangedAction ifNil: [ ^ self ].
	editorChangedAction value: anEditor
]

{ #category : #accessing }
StBrowserEditorContainerPresenter >> editors [

	^ editorNotebook pages collect: [ :each | each editor ]
]

{ #category : #testing }
StBrowserEditorContainerPresenter >> hasEditorSuchAs: aBlock [

	^ self editors anySatisfy: aBlock
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
		| pageToSelect |
	
		anAssociatedEditorSet editors do: [ :each | 
			self 
				pushEditor: each
				then: [ :aPage | 
					(anAssociatedEditorSet default = each) 
						ifTrue: [ pageToSelect := aPage ] ] ].
		self resortEditors.
		pageToSelect ifNotNil: [ editorNotebook selectPage: pageToSelect ].
		editorNotebook selectedPage 
			ifNotNil: [ :aPage | self editorChanged: aPage editor ] ]
]

{ #category : #'private - pushing' }
StBrowserEditorContainerPresenter >> pushEditor: anEditor then: aBlock [

	editorNotebook pages withIndexDo: [ :eachPage :index | | editor |
		editor := eachPage editor.
		(editor isSameAs: anEditor) ifTrue: [ 
			editor replaceWith: anEditor.
			editor updateNotebookPage: eachPage.
			aBlock value: eachPage.
			^ self ] ].

	self basicPushEditor: anEditor.
	aBlock value: editorNotebook pages last
]

{ #category : #accessing }
StBrowserEditorContainerPresenter >> removeEditorsMatching: aBlock [

	(editorNotebook pages 
		select: [ :each | aBlock value: each editor ])
		do: [ :each | editorNotebook removePage: each ]
]

{ #category : #private }
StBrowserEditorContainerPresenter >> resortEditors [
	| sortedPages |
	
	sortedPages := editorNotebook pages sorted: [ :aPage | aPage editor tabPriority ] ascending.
	sortedPages = editorNotebook pages ifTrue: [ ^ self ].

	"self application defer: [" 
		editorNotebook removeAll.
		sortedPages do: [ :each | editorNotebook addPage: each ] "]"
]

{ #category : #accessing }
StBrowserEditorContainerPresenter >> selectEditor: aPresenter [
	
	editorNotebook selectPageIndex: (self editors indexOf: aPresenter)
]

{ #category : #events }
StBrowserEditorContainerPresenter >> whenEditorChangedDo: aBlock [
	
	editorChangedAction := aBlock. 
	editorNotebook whenSelectedPageChangedDo: [ :aPage |
		aBlock value: aPage editor ]
]
