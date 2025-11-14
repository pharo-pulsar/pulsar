Class {
	#name : 'DockRequestDialog',
	#superclass : 'SpRequestDialog',
	#instVars : [
		'titlePresenter',
		'responseAreaPresenter'
	],
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'accessing' }
DockRequestDialog class >> defaultPreferredExtent [

	^ 350@100
]

{ #category : 'initialization' }
DockRequestDialog >> addButtonsTo: aDialogWindowPresenter [

	responseAreaPresenter add: (self newButton 
		label: self cancelLabel;
		action: [ self cancel ]).
	responseAreaPresenter addSuggested: (self newButton 
		label: self acceptLabel;
		action: [ self accept ])
]

{ #category : 'layout' }
DockRequestDialog >> defaultLayout [

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
			hAlignCenter;
			add: titlePresenter;
			yourself)
			expand: false;
		add: label expand: false;
		add: textInput expand: false;
		add: errorLabel expand: false;
		add: self newNullPresenter;
		add: responseAreaPresenter expand: false; 
		yourself
]

{ #category : 'initialization' }
DockRequestDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter 
		initialExtent: self extent;
		withoutDecorations;
		withoutButtons.
		
	titlePresenter label: self title.
	
	self addButtonsTo: aDialogWindowPresenter.
	self centerToParentWindow: aDialogWindowPresenter
]

{ #category : 'initialization' }
DockRequestDialog >> initializePresenters [

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
DockRequestDialog >> newDialogLabel [

	^ self newLabel
		addStyle: 'body';
		useMarkup;
		beWrap;
		beJustifyCenter;
		yourself
]

{ #category : 'private' }
DockRequestDialog >> setLabel: aString [

	label label: aString
]
