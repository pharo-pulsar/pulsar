Class {
	#name : 'PulsarInformDialog',
	#superclass : 'SpInformDialog',
	#instVars : [
		'titlePresenter',
		'responseAreaPresenter'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'accessing' }
PulsarInformDialog class >> defaultPreferredExtent [

	^ 350@100
]

{ #category : 'initialization' }
PulsarInformDialog >> addButtonsTo: aDialogWindowPresenter [

	responseAreaPresenter addSuggested: (self newButton 
		label: self acceptLabel;
		action: [ self accept ])
]

{ #category : 'layout' }
PulsarInformDialog >> defaultLayout [

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
PulsarInformDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter 
		initialExtent: self extent;
		withoutDecorations;
		withoutButtons.
		
	titlePresenter label: self title.
	
	self addButtonsTo: aDialogWindowPresenter.
	self centerToParentWindow: aDialogWindowPresenter
]

{ #category : 'initialization' }
PulsarInformDialog >> initializePresenters [

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
PulsarInformDialog >> newDialogLabel [

	^ self newLabel
		addStyle: 'body';
		useMarkup;
		beWrap;
		beJustifyCenter;
		yourself
]

{ #category : 'private' }
PulsarInformDialog >> setLabel: aString [

	label label: aString
]
