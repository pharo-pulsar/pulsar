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
StBrowserEditorContainerPresenter >> pushEditors: aCollection [

	editors addAll: aCollection.
	self updatePresenter.
	editorNotebook selectPageIndex: (editors indexOf: aCollection last)
]

{ #category : #accessing }
StBrowserEditorContainerPresenter >> removeEditorsMatching: aBlock [
	| toRemove |

	toRemove := self editors select: aBlock.
	toRemove ifEmpty: [ ^ self ].
	self editors removeAll: toRemove.
	self updatePresenter
]

{ #category : #initialization }
StBrowserEditorContainerPresenter >> updatePresenter [

	editorNotebook removeAll.
	self editors do: [ :each | 
		each addToNotebook: editorNotebook ]
]
