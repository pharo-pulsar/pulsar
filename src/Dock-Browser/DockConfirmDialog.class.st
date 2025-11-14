Class {
	#name : 'DockConfirmDialog',
	#superclass : 'SpConfirmDialog',
	#instVars : [
		'titlePresenter',
		'responseAreaPresenter'
	],
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'accessing' }
DockConfirmDialog class >> defaultPreferredExtent [

	^ 350@100
]

{ #category : 'initialization' }
DockConfirmDialog >> addButtonsTo: aDialogWindowPresenter [

	responseAreaPresenter add: (self newButton 
		label: self cancelLabel;
		action: [ self cancel ]).
	responseAreaPresenter addSuggested: (self newButton 
		label: self acceptLabel;
		action: [ self accept ])
]

{ #category : 'layout' }
DockConfirmDialog >> defaultLayout [

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
			hAlignCenter;
			add: titlePresenter;
			yourself)
			expand: false;
		add: label expand: false;
		add: self newNullPresenter;
		add: responseAreaPresenter expand: false; 
		yourself
]

{ #category : 'initialization' }
DockConfirmDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter 
		initialExtent: self extent;
		withoutDecorations;
		withoutButtons.
		
	titlePresenter label: self title.
	
	self addButtonsTo: aDialogWindowPresenter.
	self centerToParentWindow: aDialogWindowPresenter
]

{ #category : 'initialization' }
DockConfirmDialog >> initializePresenters [

	self addStyle: 'message-area'.
	self addStyle: 'has-heading'.
	self addStyle: 'has-body'.

	super initializePresenters.

	titlePresenter := self newLabel. 
	titlePresenter addStyle: 'title-2'.
	titlePresenter addStyle: 'title'.
	
	responseAreaPresenter := self instantiate: SpResponseAreaPresenter.
	responseAreaPresenter beHomogeneous
]

{ #category : 'private' }
DockConfirmDialog >> newDialogLabel [

	^ self newLabel
		addStyle: 'body';
		useMarkup;
		beWrap;
		beJustifyCenter;
		yourself
]

{ #category : 'private' }
DockConfirmDialog >> setLabel: aString [

	label label: aString
]
