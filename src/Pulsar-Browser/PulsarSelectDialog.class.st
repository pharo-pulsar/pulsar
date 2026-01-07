Class {
	#name : 'PulsarSelectDialog',
	#superclass : 'SpSelectDialog',
	#instVars : [
		'titlePresenter',
		'responseAreaPresenter'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'initialization' }
PulsarSelectDialog >> addButtonsTo: aDialogWindowPresenter [

	responseAreaPresenter add: (self newButton 
		label: self cancelLabel;
		action: [ self cancel ]).
	responseAreaPresenter addSuggested: (self newButton 
		label: self acceptLabel;
		action: [ self accept ])
]

{ #category : 'layout' }
PulsarSelectDialog >> defaultLayout [

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
			hAlignCenter;
			add: titlePresenter;
			yourself)
			expand: false;
		add: label expand: false;
		add: list;
		add: responseAreaPresenter expand: false; 
		yourself
]

{ #category : 'initialization' }
PulsarSelectDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter 
		initialExtent: self extent;
		withoutDecorations;
		withoutButtons.
		
	titlePresenter label: self title.
	
	self addButtonsTo: aDialogWindowPresenter.
	self centerToParentWindow: aDialogWindowPresenter
]

{ #category : 'initialization' }
PulsarSelectDialog >> initializePresenters [

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
PulsarSelectDialog >> newDialogLabel [

	^ self newLabel
		addStyle: 'body';
		useMarkup;
		beWrap;
		beJustifyCenter;
		yourself
]

{ #category : 'private' }
PulsarSelectDialog >> setLabel: aString [

	label label: aString
]
