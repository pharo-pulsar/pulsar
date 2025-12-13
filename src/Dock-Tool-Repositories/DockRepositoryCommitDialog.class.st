Class {
	#name : 'DockRepositoryCommitDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'textPresenter',
		'placeholderPresenter'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'accessing' }
DockRepositoryCommitDialog class >> defaultPreferredExtent [

	^ 700@300
]

{ #category : 'accessing' }
DockRepositoryCommitDialog class >> ghostText [

	^ 'What changed?
Why did it change?
Anything someone reading this in 6 months should know?

(Keep the first line short; add details below.)

WARNING: Hitting enter will trigger the commit. Use shft+enter to add a new line.  
'
]

{ #category : 'layout' }
DockRepositoryCommitDialog >> defaultLayout [

	^ SpOverlayLayout new 
		addOverlay: placeholderPresenter withConstraints: [ :c | c vAlignStart; hAlignStart ];
		child: textPresenter;
		yourself	
]

{ #category : 'initialization' }
DockRepositoryCommitDialog >> initializeDialogWindow: aDialogWindowPresenter [

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
DockRepositoryCommitDialog >> initializePresenters [

	self addStyle: 'dockRepositoryCommit'.

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
DockRepositoryCommitDialog >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Commit message'
]

{ #category : 'accessing' }
DockRepositoryCommitDialog >> message [
	"retrieve the message"

	^ textPresenter text
]
