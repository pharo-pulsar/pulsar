Class {
	#name : 'PulsarRequestDialog',
	#superclass : 'SpRequestDialog',
	#instVars : [
		'titlePresenter',
		'responseAreaPresenter'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'accessing' }
PulsarRequestDialog class >> defaultPreferredExtent [

	^ 350@100
]

{ #category : 'initialization' }
PulsarRequestDialog >> addButtonsTo: aDialogWindowPresenter [

	responseAreaPresenter add: (self newButton 
		label: self cancelLabel;
		action: [ self cancel ]).
	responseAreaPresenter addSuggested: (self newButton 
		label: self acceptLabel;
		action: [ self accept ])
]

{ #category : 'layout' }
PulsarRequestDialog >> defaultLayout [

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
PulsarRequestDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter 
		initialExtent: self extent;
		withoutDecorations;
		withoutButtons.
		
	titlePresenter label: self title.
	
	self addButtonsTo: aDialogWindowPresenter.
	self centerToParentWindow: aDialogWindowPresenter
]

{ #category : 'initialization' }
PulsarRequestDialog >> initializePresenters [

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
PulsarRequestDialog >> newDialogLabel [

	^ self newLabel
		addStyle: 'body';
		useMarkup;
		beWrap;
		beJustifyCenter;
		yourself
]

{ #category : 'api' }
PulsarRequestDialog >> placeholder: aString [

	textInput placeholder: aString
]

{ #category : 'private' }
PulsarRequestDialog >> setLabel: aString [

	label label: aString
]
