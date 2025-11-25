Class {
	#name : 'DockChangesSessionPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + DockTActionContainer',
	#classTraits : 'SpTModel classTrait + DockTActionContainer classTrait',
	#instVars : [
		'entryListPresenter',
		'entryPatchPresenter',
		'headerPresenter'
	],
	#category : 'Dock-Tool-Changes',
	#package : 'Dock-Tool-Changes'
}

{ #category : 'accessing - actions' }
DockChangesSessionPresenter class >> defineActionsOn: aBuilder [
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
DockChangesSessionPresenter >> actionableChanges [

	^  entryListPresenter selectedItems 
		select: [ :each | each content isCodeChange ]
]

{ #category : 'testing' }
DockChangesSessionPresenter >> canApplyOrRevertChanges [
	
	^ self actionableChanges isNotEmpty
]

{ #category : 'initialization' }
DockChangesSessionPresenter >> connectPresenters [

	entryListPresenter transmitDo: [ :anEntry | 
		self updateToolbar.
		self updatePatchWith: anEntry ]
]

{ #category : 'layout' }
DockChangesSessionPresenter >> defaultLayout [

	^ SpPanedLayout newVertical 
		add: (SpBoxLayout newVertical 
			add: headerPresenter expand: false;
			add: entryListPresenter;
			yourself);
		add: entryPatchPresenter;
		yourself
]

{ #category : 'private - actions' }
DockChangesSessionPresenter >> doApply [
	
	self performAction: #beForRedo
]

{ #category : 'private - actions' }
DockChangesSessionPresenter >> doRevert [

	self performAction: #beForUndo
]

{ #category : 'initialization' }
DockChangesSessionPresenter >> initializeDialogWindow: aDialogWindowPresenter [

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
DockChangesSessionPresenter >> initializePresenters [

	"session"
	headerPresenter := self instantiate: DockEditorToolbarPresenter.
	entryListPresenter := self newEasyListView
		addStyle: 'stList';
		beMultipleSelection;
		rowPresenterClass: DockEntryRowPresenter;
		actions: self sessionActions;
		yourself.
	entryPatchPresenter := self instantiate: DockChangesEntryPatchPresenter.
	
	"actions needs to be later because they require entryListPresenter to be 
	 initialized to check enabled/disabled status"  
	headerPresenter contentActions: self sessionActions
]

{ #category : 'private - actions' }
DockChangesSessionPresenter >> performAction: aSelector [

	| entries changesPresenter |
	
	entries := self actionableChanges.
	changesPresenter := self 
		instantiate: self class 
		on: ((DockChangesSessionModel 
			newFileReference: self model fileReference
			entries: entries)
			perform: aSelector).
	changesPresenter openModal
]

{ #category : 'private - accessing' }
DockChangesSessionPresenter >> sessionActions [

	^ self actions actionsFor: #sessionActions
]

{ #category : 'initialization' }
DockChangesSessionPresenter >> updatePatchWith: aCollectionOfEntries [
	| entry |
	
	(aCollectionOfEntries isEmpty or: [ aCollectionOfEntries size > 1 ]) 
		ifTrue: [ 
			entryPatchPresenter beEmpty.
			^ self ].
	
	entryPatchPresenter model: aCollectionOfEntries first
]

{ #category : 'initialization' }
DockChangesSessionPresenter >> updatePresenter [

	self model ifNil: [
		headerPresenter title: 'No session selected'.
		entryListPresenter items: #().
		^ self ].
	
	headerPresenter title: 'Session: ', self model fileReference modificationTime epiceaBrowsersAsString. 
	entryListPresenter items: self model entries
]

{ #category : 'initialization' }
DockChangesSessionPresenter >> updateToolbar [

	self sessionActions allCommands do: [ :each | each updateEnableStatus ]
]
