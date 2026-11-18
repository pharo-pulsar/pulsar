"
I resolve the conflict produced when checking out a remote branch that has a local branch with the same name pointing to a different commit. I am used by PulsarRepositoryCheckoutPreviewModel.
"
Class {
	#name : 'PulsarRepositoryCheckoutConflictDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'remoteBranch',
		'existingBranch',
		'messagePresenter',
		'checkoutLocalPresenter',
		'newBranchPresenter',
		'newBranchNamePresenter',
		'resetLocalPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View'
}

{ #category : 'private' }
PulsarRepositoryCheckoutConflictDialog >> confirmReset [

	^ self application newConfirm
		title: 'Reset local branch';
		message: f'Reset <b>[existingBranch name]</b> to <b>[remoteBranch name]</b>? Uncommitted changes and local commits not pushed to the remote will be lost.';
		acceptLabel: 'Reset';
		openModalWithParent: self window
]

{ #category : 'layout' }
PulsarRepositoryCheckoutConflictDialog >> defaultLayout [

	^ SpBoxLayout newVertical
		spacing: 8;
		borderWidth: 10;
		add: messagePresenter expand: false;
		add: checkoutLocalPresenter expand: false;
		add: newBranchPresenter expand: false;
		add: (SpBoxLayout newLeftToRight
			add: '' expand: false;
			add: newBranchNamePresenter;
			yourself) expand: false;
		add: resetLocalPresenter expand: false;
		add: (self newLabel
			label: 'Uncommitted changes and local commits not pushed to the remote will be lost.';
			yourself) expand: false;
		yourself
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutConflictDialog >> existingBranch [

	^ existingBranch
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutConflictDialog >> existingBranch: aLocalBranch [

	existingBranch := aLocalBranch.
	self updateMessage
]

{ #category : 'initialization' }
PulsarRepositoryCheckoutConflictDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: 'Cancel' do: [ :presenter |
			presenter triggerCancelAction.
			presenter close ];
		addDefaultButton: 'Checkout' do: [ :presenter |
			self validateThen: [
				presenter triggerOkAction.
				presenter beOk.
				presenter close ] ]
]

{ #category : 'initialization' }
PulsarRepositoryCheckoutConflictDialog >> initializePresenters [

	self addStyle: 'pulsarDialog'.

	messagePresenter := self newLabel
		useMarkup;
		beWrap;
		yourself.
	checkoutLocalPresenter := self newRadioButton
		label: 'Checkout existing local branch';
		yourself.
	newBranchPresenter := self newRadioButton
		label: 'Checkout remote as a new branch';
		yourself.
	resetLocalPresenter := self newRadioButton
		label: 'Reset local branch to the remote commit';
		yourself.
	checkoutLocalPresenter associatedRadioButtons: {
		newBranchPresenter.
		resetLocalPresenter }.

	newBranchNamePresenter := self newTextInput
		placeholder: 'new branch name';
		enabled: false;
		yourself.
	checkoutLocalPresenter whenChangedDo: [ :state |
		state ifTrue: [ newBranchNamePresenter enabled: false ] ].
	newBranchPresenter whenChangedDo: [ :state |
		newBranchNamePresenter enabled: state ].
	resetLocalPresenter whenChangedDo: [ :state |
		state ifTrue: [ newBranchNamePresenter enabled: false ] ]
]

{ #category : 'initialization' }
PulsarRepositoryCheckoutConflictDialog >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Branch conflict';
		initialExtent: 650 @ 320
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutConflictDialog >> newBranchName [

	^ newBranchNamePresenter text trimBoth
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutConflictDialog >> remoteBranch [

	^ remoteBranch
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutConflictDialog >> remoteBranch: aRemoteBranch [

	remoteBranch := aRemoteBranch.
	self updateMessage
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutConflictDialog >> repository [

	^ self remoteBranch repository
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutConflictDialog >> resolution [

	checkoutLocalPresenter state ifTrue: [ ^ #checkoutLocal ].
	newBranchPresenter state ifTrue: [ ^ #newBranch ].
	resetLocalPresenter state ifTrue: [ ^ #resetLocal ].
	^ nil
]

{ #category : 'private' }
PulsarRepositoryCheckoutConflictDialog >> updateMessage [

	messagePresenter ifNil: [ ^ self ].
	(remoteBranch isNil or: [ existingBranch isNil ]) ifTrue: [ ^ self ].
	messagePresenter label: f'The local branch <b>[existingBranch name]</b> already exists and <b>[remoteBranch name]</b> points to a different commit. What do you want to do?'
]

{ #category : 'initialization' }
PulsarRepositoryCheckoutConflictDialog >> updatePresenter [

	checkoutLocalPresenter state: true.
	self updateMessage
]

{ #category : 'private' }
PulsarRepositoryCheckoutConflictDialog >> validate [

	self resolution = #newBranch ifTrue: [ ^ self validateNewBranchName ].
	self resolution = #resetLocal ifTrue: [ ^ self confirmReset ].
	^ true
]

{ #category : 'private' }
PulsarRepositoryCheckoutConflictDialog >> validateNewBranchName [

	| name |

	name := self newBranchName.
	self
		assert: name isNotEmpty
		description: 'Please enter a name for the new branch.'.
	self
		assert: (name noneSatisfy: #isSeparator)
		description: 'Branch names cannot contain spaces.'.
	self
		assert: (self repository localBranches noneSatisfy: [ :each | each name = name ])
		description: 'A local branch with that name already exists.'.
	^ true
]

{ #category : 'private' }
PulsarRepositoryCheckoutConflictDialog >> validateThen: aBlock [

	| isValid |

	isValid := false.
	[ isValid := self validate ]
		on: AssertionFailure
		do: [ :e |
			self application newAlert
				title: 'Invalid value';
				message: e messageText;
				openModalWithParent: self window ].
	isValid ifTrue: [ aBlock value ]
]
