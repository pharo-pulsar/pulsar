Class {
	#name : 'PulsarRepositoryRepairDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'optionsListPresenter',
		'detailPresenter',
		'model',
		'selectedOption',
		'reasonPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View-Repositories',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Repositories'
}

{ #category : 'instance creation' }
PulsarRepositoryRepairDialog class >> newApplication: anApplication model: aModel [

	^ self basicNew
		application: anApplication;
		setModelBeforeInitialization: aModel;
		yourself
]

{ #category : 'actions' }
PulsarRepositoryRepairDialog >> accept [

	selectedOption ifNil: [ ^ self ].

	self window close.
	selectedOption onSuccess: [
		self application resendAnnouncement: (PulsarRepositoryModified newValue: self model) ].
	selectedOption
		executeWithContext: self
		model: self model
]

{ #category : 'layout' }
PulsarRepositoryRepairDialog >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		borderWidth: 5;
		spacing: 5;
		add: reasonPresenter height: 80;
		add: optionsListPresenter height: 120;
		add: detailPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryRepairDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: 'Cancel' do: [ :presenter |
			presenter
				beCancel;
				close ];
		addDefaultButton: 'Repair' do: [ :presenter |
			self accept.
			presenter
				triggerOkAction;
				beOk;
				close ]
]

{ #category : 'initialization' }
PulsarRepositoryRepairDialog >> initializeOptionsList [

	optionsListPresenter
		hideColumnHeaders;
		addColumn: (SpCompositeTableColumn new
			addColumn: (SpImageTableColumn new
				width: 20;
				evaluated: #icon;
				beNotExpandable;
				yourself);
			addColumn: (SpStringTableColumn new
				evaluated: #title;
				yourself);
			yourself);
		items: self model repairActions;
		whenSelectionChangedDo: [ :selection |
			self selectionChanged: selection selectedItem ];
		whenActivatedDo: [ :selection |
			selection selectedItem ifNotNil: [ self accept ] ].

	optionsListPresenter items isEmpty ifFalse: [
		optionsListPresenter selectItem: optionsListPresenter items first ]
]

{ #category : 'initialization' }
PulsarRepositoryRepairDialog >> initializePresenters [

	self addStyle: 'pulsarDialog'.

	reasonPresenter := self newText
		beNotEditable;
		beWrapWord;
		addStyle: 'iceTipReadonly';
		yourself.
	optionsListPresenter := self newTable.
	detailPresenter := self newText
		beNotEditable;
		beWrapWord;
		addStyle: 'iceTipReadonly';
		yourself.

	reasonPresenter text: self model longStatus.
	self initializeOptionsList
]

{ #category : 'initialization' }
PulsarRepositoryRepairDialog >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Repair repository';
		initialExtent: 600@420
]

{ #category : 'accessing' }
PulsarRepositoryRepairDialog >> model [

	^ model
]

{ #category : 'accessing' }
PulsarRepositoryRepairDialog >> model: anObject [

	model := anObject
]

{ #category : 'initialization' }
PulsarRepositoryRepairDialog >> setModelBeforeInitialization: anObject [

	model := anObject
]

{ #category : 'private' }
PulsarRepositoryRepairDialog >> selectionChanged: anOption [

	selectedOption := anOption.
	detailPresenter text: (selectedOption
		ifNil: [ '' ]
		ifNotNil: [ selectedOption help ])
]
