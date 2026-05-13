Class {
	#name : 'PulsarRepositoryRemoteDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'namePresenter',
		'urlPresenter',
		'windowTitle',
		'acceptLabel'
	],
	#category : 'Pulsar-Tool-Repositories-View-Remotes',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Remotes'
}

{ #category : 'initialization' }
PulsarRepositoryRemoteDialog >> beForAddition [

	windowTitle := 'Add Remote'.
	acceptLabel := 'Add'
]

{ #category : 'initialization' }
PulsarRepositoryRemoteDialog >> beForEditionOf: aRemote [

	windowTitle := 'Edit Remote'.
	acceptLabel := 'Save'.
	
	namePresenter text: aRemote name.
	urlPresenter text: aRemote url
]

{ #category : 'layout' }
PulsarRepositoryRemoteDialog >> defaultLayout [

	^ SpGridLayout new
		beColumnNotHomogeneous;
		column: 2 expand: true;
		build: [ :builder | builder 
			add: 'Name'; add: namePresenter; nextRow;
			add: 'URL'; add: urlPresenter ];
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryRemoteDialog >> initialExtent [
		
	^ 650@250
]

{ #category : 'initialization' }
PulsarRepositoryRemoteDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: 'Cancel' do: [ :presenter | 
			presenter triggerCancelAction.
			presenter close ];
		addDefaultButton: (acceptLabel ifNil: [ 'Ok' ]) do: [ :presenter | 
			self validateThen: [
				presenter triggerOkAction.
				presenter beOk.
				presenter close ] ]
]

{ #category : 'initialization' }
PulsarRepositoryRemoteDialog >> initializePresenters [

	self addStyle: 'pulsarRepositoryRemoteDialog'.

	namePresenter := self newTextInput
		placeholder: 'origin';
		yourself.
	urlPresenter := self newTextInput
		placeholder: 'git@my-git-forge.net:user/project.git';
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryRemoteDialog >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: (windowTitle ifNil: [ 'Remote' ]);
		initialExtent: self initialExtent
]

{ #category : 'accessing' }
PulsarRepositoryRemoteDialog >> name [

	^ namePresenter text trimBoth
]

{ #category : 'accessing' }
PulsarRepositoryRemoteDialog >> url [

	^ urlPresenter text trimBoth
]

{ #category : 'private' }
PulsarRepositoryRemoteDialog >> validateThen: aBlock [
	| result |

	result := false.
	[ 
		self assert: (namePresenter text trimBoth isNotEmpty) description: 'Name cannot be empty.'.
		self assert: (urlPresenter text trimBoth isNotEmpty) description: 'URL cannot be empty.'.
		result := true ] 
	on: AssertionFailure
	do: [ :e | 
		self application newAlert
			title: 'Error';
			message: e messageText;
			openModalWithParent: self window ].
			
	result ifFalse: [ ^ self ].
	
	aBlock value
]
