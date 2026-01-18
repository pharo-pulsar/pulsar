Class {
	#name : 'PulsarRepositoryCommitDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'textPresenter',
		'placeholderPresenter'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'accessing' }
PulsarRepositoryCommitDialog class >> defaultPreferredExtent [

	^ 700@300
]

{ #category : 'accessing' }
PulsarRepositoryCommitDialog class >> ghostText [

	^ 'What changed?
Why did it change?
Anything someone reading this in 6 months should know?

(Keep the first line short; add details below.)

WARNING: Hitting enter will trigger the commit. Use shft+enter to add a new line.  
'
]

{ #category : 'layout' }
PulsarRepositoryCommitDialog >> defaultLayout [

	^ SpOverlayLayout new 
		addOverlay: placeholderPresenter withConstraints: [ :c | c vAlignStart; hAlignStart ];
		child: textPresenter;
		yourself	
]

{ #category : 'initialization' }
PulsarRepositoryCommitDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: 'Cancel' do: [ :presenter | 
			presenter triggerCancelAction.
			presenter close ];
		addDefaultButton: 'Commit' do: [ :presenter | 
			presenter triggerOkAction.
			presenter beOk.
			presenter close ]
]

{ #category : 'initialization' }
PulsarRepositoryCommitDialog >> initializePresenters [

	self addStyle: 'pulsarRepositoryCommit'.

	placeholderPresenter := self newLabel
		addStyle: 'dim';
		addStyle: 'placeholder';
		label: self class ghostText;
		yourself.

	textPresenter := self newText
		whenTextChangedDo: [ :aString | placeholderPresenter visible: aString isEmpty ];
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryCommitDialog >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Commit message'
]

{ #category : 'accessing' }
PulsarRepositoryCommitDialog >> message [
	"retrieve the message"

	^ textPresenter text
]
