"
A combined directory browser showing a tree list of directories and files on the left, with an inspector on the right.

It follows the same pattern as PulsarMessageBrowser: a header toolbar, a list/tree, and a content editor. Clicking a file in the tree opens it in the embedded PulsarFileEditor. The model is a PulsarDirectoryModel wrapping a root directory FileReference.

For the moment, the editorPresenter (sensed to contain a preview in this case) is not active.
"
Class {
	#name : 'PulsarDirectoryBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTSnapshot + PulsarTEditor',
	#classTraits : 'SpTModel classTrait + PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTSnapshot classTrait + PulsarTEditor classTrait',
	#instVars : [
		'directoryTreePresenter',
		'editorPresenter',
		'headerPresenter'
	],
	#category : 'Pulsar-Tool-FileEditor-View',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'View'
}

{ #category : 'visiting' }
PulsarDirectoryBrowser >> acceptFile: aFileModel [

	
	self withPopoverDo: [ :aPopover | aPopover dismiss ].
	self notifyActivateEntity: aFileModel
]

{ #category : 'initialization' }
PulsarDirectoryBrowser >> connectPresenters [

	"directoryTreePresenter outputSelectionPort 
		transmitDo: [ :aModel | 
			(aModel isNotNil and: [ aModel isDirectory not ]) 
				ifTrue: [ editorPresenter model: aModel ] ]."
				
	directoryTreePresenter outputActivationPort
		transmitDo: [ :aFileModel | self acceptFile: aFileModel ]
]

{ #category : 'api - focus' }
PulsarDirectoryBrowser >> defaultKeyboardFocus [

	^ directoryTreePresenter
]

{ #category : 'layout' }
PulsarDirectoryBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: headerPresenter expand: false;
		  add: (SpPanedLayout newHorizontal
				   add: directoryTreePresenter;
				   "add: editorPresenter;"
				   yourself);
		  yourself
]

{ #category : 'private - definitions' }
PulsarDirectoryBrowser >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder
		addGroup: #actions with: [ :group | group
			beDisplayedAsGroup;
			addActionWith: [ :action | action
				name: 'Open file location';
				iconName: 'open';
				description: 'Open current file location on the external file manager';
				action: [ self doOpenCurrentFolder ] ];
			addActionWith: [ :action | action
				name: 'Open terminal';
				iconName: 'console';
				description: 'Open a terminal on current file location';
				action: [ self doOpenTerminalOnCurrentFolder ] ] ];
		addGroup: #directory with: [ :group | group
			priority: 10;
			name: 'Directory';
			beDisplayedAsGroup;
			addActionWith: [ :action | action
				name: 'New file';
				description: 'Create a new empty file';
				iconName: 'addFile';
				action: [ self doAddFileCommand: action ] ];
			addActionWith: [ :action | action
				name: 'New folder';
				description: 'Create a new directory';
				iconName: 'addFolder';
				action: [ self doAddFolderCommand: action ] ] ];
		addGroup: #directoryCritical with: [ :group | group
			priority: 1000;
			name: 'DANGER ZONE';
			beDisplayedAsGroup;
			addActionWith: [ :action | action
				name: 'Remove';
				description: 'Remove selected file or folder';
				shortcutKey: $x mod1 shift;
				action: [ self doRemoveSelectedFileOrFolder ] ] ]
]

{ #category : 'private - actions' }
PulsarDirectoryBrowser >> doAddFileCommand: aCommand [
	| dialog fileName selectedDir reference |
	
	selectedDir := self selectedDirectoryModel.

	dialog := self instantiate: PulsarRequestPresenter.
	dialog label: 'File Name'.
	dialog acceptLabel: 'Create'.

	dialog asPopover
		relativeTo: aCommand presenter;
		popupModalAndWait.
	dialog isOk ifFalse: [ ^ self ].

	fileName := dialog text.
	reference := selectedDir createFileNamed: fileName.
	self updatePresenter.
	directoryTreePresenter 
		selectItem: reference;
		takeKeyboardFocus
]

{ #category : 'private - actions' }
PulsarDirectoryBrowser >> doAddFolderCommand: aCommand [
	| dialog folderName selectedDir reference |
	
	selectedDir := self selectedDirectoryModel.

	dialog := self instantiate: PulsarRequestPresenter.
	dialog label: 'Folder Name'.
	dialog acceptLabel: 'Create'.

	dialog asPopover
		relativeTo: aCommand presenter;
		popupModalAndWait.
	dialog isOk ifFalse: [ ^ self ].

	folderName := dialog text.
	reference := selectedDir createDirectoryNamed: folderName.
	self updatePresenter.
	directoryTreePresenter 
		selectItem: reference;
		takeKeyboardFocus
]

{ #category : 'private - actions' }
PulsarDirectoryBrowser >> doCopyToClipboard [

	self model ifNil: [ ^ self ].
	self application copyToClipboard: self model fullName.
	self withWindowDo: [ :w | w inform: 'Copied to clipboard' ]
]

{ #category : 'private - actions' }
PulsarDirectoryBrowser >> doOpenCurrentFolder [

	self model openInOSFileBrowser

]

{ #category : 'private - actions' }
PulsarDirectoryBrowser >> doOpenTerminalOnCurrentFolder [

	self model openTerminal
]

{ #category : 'private - actions' }
PulsarDirectoryBrowser >> doRemoveSelectedFileOrFolder [
	"Remove the selected file or folder after user confirmation."
	| okToRemove selectedFile |
	
	selectedFile := directoryTreePresenter selectedItem.
	selectedFile ifNil: [ ^ self ].

	okToRemove := self application newConfirm
		title: 'Remove';
		message: ('Do you want to remove {1}?' format: { selectedFile name });
		acceptLabel: 'Remove';
		openModalWithParent: self window.
	okToRemove ifFalse: [ ^ self ].

	selectedFile delete.
	self updatePresenter
]

{ #category : 'events' }
PulsarDirectoryBrowser >> eventModelChanged: ann [

	ann value = self model ifFalse: [ ^ self ].
	self updatePresenter
]

{ #category : 'initialization' }
PulsarDirectoryBrowser >> initializePresenters [

	self addStyle: 'pulsarDirectoryBrowser'.

	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	headerPresenter actions: (self actions actionsFor: #actions).
	
	headerPresenter addPresenter: (self newToolbar 
		beIcons;
		fillWith: (self actions actionsFor: #directory)).

	directoryTreePresenter := self newEasyTreeListView
		addStyle: 'stTree';
		children: [ :aModel | aModel children ];
		display: [ :aModel | aModel name ];
		displayIcon: [ :aModel | self iconNamed: aModel iconName ];
		actions: (self actions actionsForAll: #( directory directoryCritical ));
		yourself "editorPresenter := self instantiate: PulsarFileEditor"
]

{ #category : 'testing' }
PulsarDirectoryBrowser >> isDirty [

	^ false
]

{ #category : 'accessing - model' }
PulsarDirectoryBrowser >> model: aModel [

	model := aModel.
	self updatePresenter
]

{ #category : 'private - announcing' }
PulsarDirectoryBrowser >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	anEntity canBeActivated ifFalse: [ ^ self ].
	
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private' }
PulsarDirectoryBrowser >> panelFocused [

	logger trace.
	self notifyEditorActivated.
	self takeKeyboardFocus
]

{ #category : 'accessing' }
PulsarDirectoryBrowser >> panelPlacedIconName [

	^ #folder
]

{ #category : 'accessing' }
PulsarDirectoryBrowser >> raise [

	self withPanelWidgetDo: [ :aWindow | aWindow raiseAndTakeKeyboardFocus ]
]

{ #category : 'initialization' }
PulsarDirectoryBrowser >> registerToBrowser: aPulsarBrowser [

	self notificationCenter: aPulsarBrowser notificationCenter
]

{ #category : 'initialization' }
PulsarDirectoryBrowser >> registerToEvents [

	super registerToEvents.
	self announcer when: PulsarModelChanged send: #eventModelChanged: to: self
]

{ #category : 'private - accessing' }
PulsarDirectoryBrowser >> selectedDirectoryModel [
	"Return the selected item if it is a directory model, otherwise return the root model."

	| selected |
	selected := directoryTreePresenter selectedItem.
	^ (selected isNotNil and: [ selected isDirectory ])
		  ifTrue: [ selected ]
		  ifFalse: [ self model ]
]

{ #category : 'accessing - model' }
PulsarDirectoryBrowser >> setModelBeforeInitialization: aModel [

	model := aModel
]

{ #category : 'accessing - snapshot' }
PulsarDirectoryBrowser >> snapshot [

	^ PulsarDirectorySnapshot on: self
]

{ #category : 'initialization' }
PulsarDirectoryBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].

	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb 
			addSegment: self model fullName;
			addButtonSegment: 'copy-to-clipboard'
				help: ('Copy {1} to the clipboard' format: { self model fullName })
				action: [ self doCopyToClipboard ] ].
	directoryTreePresenter roots: self model children
]
