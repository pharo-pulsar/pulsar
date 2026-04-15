Class {
	#name : 'PulsarRepositorySelectBranchPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'titlePresenter',
		'messagePresenter',
		'listPresenter',
		'shouldExcludeHead'
	],
	#category : 'Pulsar-Tool-Repositories-View',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View'
}

{ #category : 'initialization' }
PulsarRepositorySelectBranchPresenter >> applyFilter: aCollection [ 

	shouldExcludeHead ifFalse: [ ^ aCollection ].
	
	^ aCollection reject: #isHead
]

{ #category : 'initialization' }
PulsarRepositorySelectBranchPresenter >> connectPresenters [

	listPresenter whenActivatedDo: [ self doAccept ]
]

{ #category : 'api - focus' }
PulsarRepositorySelectBranchPresenter >> defaultKeyboardFocus [

	^ listPresenter
]

{ #category : 'layout' }
PulsarRepositorySelectBranchPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newVertical
				hAlignCenter;
				add: titlePresenter expand: false;
				yourself)
			expand: false;
		add: messagePresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - actions' }
PulsarRepositorySelectBranchPresenter >> doAccept [

	self window 
		triggerOkAction;
		beOk; 
		close
]

{ #category : 'accessing' }
PulsarRepositorySelectBranchPresenter >> excludeHead [
	"explicitly not include current working branch (HEAD) from the list"

	shouldExcludeHead := true
]

{ #category : 'initialization' }
PulsarRepositorySelectBranchPresenter >> initialize [

	shouldExcludeHead := false.
	super initialize
]

{ #category : 'initialization' }
PulsarRepositorySelectBranchPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter 
		initialExtent: 400@500;
		withoutDecorations.
		
	aDialogWindowPresenter
		addButton: 'Cancel' do: [ :aPresenter | 
			aPresenter triggerCancelAction.
			aPresenter close ];
		addDefaultButton: 'Select' do: [ :aPresenter | 
			aPresenter triggerOkAction.
			aPresenter beOk.
			aPresenter close ]
]

{ #category : 'initialization' }
PulsarRepositorySelectBranchPresenter >> initializePresenters [

	self addStyle: 'message-area'.
	self addStyle: 'has-heading'.
	self addStyle: 'has-body'.
	
	titlePresenter := self newLabel 
		label: 'Checkout branch';
		addStyle: 'title-2';
		addStyle: 'title';
		yourself.
		
	messagePresenter := self newLabel
		addStyle: 'body';
		useMarkup;
		beWrap;
		beJustifyCenter;
		yourself.

	listPresenter := self newFilteringList
		addStyle: 'stList';
		addStyle: 'spSelectList';
		display: [ :each | each name ];
		searchMatching: [ :item :aString | 
			item name asLowercase beginsWith: aString asLowercase ];
		yourself
]

{ #category : 'accessing' }
PulsarRepositorySelectBranchPresenter >> message: aString [

	messagePresenter label: aString
]

{ #category : 'accessing' }
PulsarRepositorySelectBranchPresenter >> selectedModel [

	^ listPresenter selectedItem
]

{ #category : 'accessing' }
PulsarRepositorySelectBranchPresenter >> title: aString [

	titlePresenter label: aString
]

{ #category : 'initialization' }
PulsarRepositorySelectBranchPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	listPresenter
		items: (self applyFilter: self model localBranches), self model remoteBranches
]
