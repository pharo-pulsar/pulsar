Class {
	#name : 'PulsarChangesSessionPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTActionContainer',
	#classTraits : 'SpTModel classTrait + PulsarTActionContainer classTrait',
	#instVars : [
		'entryListPresenter',
		'entryPatchPresenter',
		'headerPresenter'
	],
	#category : 'Pulsar-Tool-Changes',
	#package : 'Pulsar-Tool-Changes'
}

{ #category : 'accessing - actions' }
PulsarChangesSessionPresenter class >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #sessionActions with: [ :group | group 
		addActionWith: [ :action | action
			name: 'Apply';
			iconName: 'redo';
			description: 'Preview the application of selected code changes (open a new window to show the effect of re-applying the changes in current image)';
			actionEnabled: [ :aContext | aContext canApplyOrRevertChanges ];
			action: [ :aContext | aContext doApply ] ];
		addActionWith: [ :action | action
			name: 'Revert';
			iconName: 'undo';
			description: 'Preview the reversion of selected code changes (open a new window to show the effect of reverting the changes in current image)';
			actionEnabled: [ :aContext | aContext canApplyOrRevertChanges ];
			action: [ :aContext | aContext doRevert ] ] ]
]

{ #category : 'private' }
PulsarChangesSessionPresenter >> actionableChanges [

	^  entryListPresenter selectedItems 
		select: [ :each | each content isCodeChange ]
]

{ #category : 'testing' }
PulsarChangesSessionPresenter >> canApplyOrRevertChanges [
	
	^ self actionableChanges isNotEmpty
]

{ #category : 'initialization' }
PulsarChangesSessionPresenter >> connectPresenters [

	entryListPresenter transmitDo: [ :anEntry | 
		self updateToolbar.
		self updatePatchWith: anEntry ]
]

{ #category : 'layout' }
PulsarChangesSessionPresenter >> defaultLayout [

	^ SpPanedLayout newVertical 
		add: (SpBoxLayout newVertical 
			add: headerPresenter expand: false;
			add: entryListPresenter;
			yourself);
		add: entryPatchPresenter;
		yourself
]

{ #category : 'private - actions' }
PulsarChangesSessionPresenter >> doApply [
	
	self performAction: #beForRedo
]

{ #category : 'private - actions' }
PulsarChangesSessionPresenter >> doRevert [

	self performAction: #beForUndo
]

{ #category : 'initialization' }
PulsarChangesSessionPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	"I do not want apply/revert buttongs"
	headerPresenter resetContentActions.
	
	aDialogWindowPresenter
		title: self model title;
		addButton: 'Cancel' do: [ :presenter | 
			presenter triggerCancelAction.
			presenter close ];
		addDefaultButton: self model actionName do: [ :presenter | 
			presenter triggerOkAction.
			presenter beOk.
			self model performAction.
			presenter close ]
]

{ #category : 'initialization' }
PulsarChangesSessionPresenter >> initializePresenters [

	"session"
	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	entryListPresenter := self newEasyListView
		addStyle: 'stList';
		beMultipleSelection;
		rowPresenterClass: PulsarEntryRowPresenter;
		actions: self sessionActions;
		yourself.
	entryPatchPresenter := self instantiate: PulsarChangesEntryPatchPresenter.
	
	"actions needs to be later because they require entryListPresenter to be 
	 initialized to check enabled/disabled status"  
	headerPresenter contentActions: self sessionActions
]

{ #category : 'private - actions' }
PulsarChangesSessionPresenter >> performAction: aSelector [

	| entries changesPresenter |
	
	entries := self actionableChanges.
	changesPresenter := self 
		instantiate: self class 
		on: ((PulsarChangesSessionModel 
			newFileReference: self model fileReference
			entries: entries)
			perform: aSelector).
	changesPresenter openModal
]

{ #category : 'private - accessing' }
PulsarChangesSessionPresenter >> sessionActions [

	^ self actions actionsFor: #sessionActions
]

{ #category : 'initialization' }
PulsarChangesSessionPresenter >> updatePatchWith: aCollectionOfEntries [
	| entry |
	
	(aCollectionOfEntries isEmpty or: [ aCollectionOfEntries size > 1 ]) 
		ifTrue: [ 
			entryPatchPresenter beEmpty.
			^ self ].
	
	entryPatchPresenter model: aCollectionOfEntries first
]

{ #category : 'initialization' }
PulsarChangesSessionPresenter >> updatePresenter [

	self model ifNil: [
		headerPresenter title: 'No session selected'.
		entryListPresenter items: #().
		^ self ].
	
	headerPresenter title: 'Session: ', self model fileReference modificationTime epiceaBrowsersAsString. 
	entryListPresenter items: self model entries
]

{ #category : 'initialization' }
PulsarChangesSessionPresenter >> updateToolbar [

	self sessionActions allCommands do: [ :each | each updateEnableStatus ]
]
