Class {
	#name : #PvEditorFooterPresenter,
	#superclass : #SpPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'toolbarPresenter',
		'actions'
	],
	#category : #'Perspective-View-Editor'
}

{ #category : #accessing }
PvEditorFooterPresenter >> actions [

	^ actions
]

{ #category : #accessing }
PvEditorFooterPresenter >> actions: anActionGroup [

	actions := anActionGroup.
	self updatePresenter
]

{ #category : #layout }
PvEditorFooterPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		vAlignCenter;
		addLast: toolbarPresenter expand: false;
		yourself
]

{ #category : #initialization }
PvEditorFooterPresenter >> initializePresenters [

	toolbarPresenter := self newToolbar
		addStyle: 'pvEditorFooterToolbar';
		displayMode: self application toolbarDisplayMode;
		yourself
]

{ #category : #initialization }
PvEditorFooterPresenter >> updatePresenter [

	toolbarPresenter removeAllItems.
	self actions ifNotNil: [ :aGroup |
		toolbarPresenter fillWith: aGroup ]
]
