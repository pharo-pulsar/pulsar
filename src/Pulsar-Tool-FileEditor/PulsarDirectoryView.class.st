"
A tree view panel that displays a directory structure for the Pulsar browser.

It shows directories and files in a tree, allowing navigation through the file system. Directories can be expanded to reveal their contents, and files can be activated to open them in a PulsarFileEditor.
"
Class {
	#name : 'PulsarDirectoryView',
	#superclass : 'PulsarCollectionView',
	#traits : 'PulsarTActionContainer',
	#classTraits : 'PulsarTActionContainer classTrait',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Pulsar-Tool-FileEditor-View',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'View'
}

{ #category : 'accessing' }
PulsarDirectoryView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 1;
		yourself
]

{ #category : 'layout' }
PulsarDirectoryView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - definitions' }
PulsarDirectoryView >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder
		addGroup: #actions with: [ :group | group
			beDisplayedAsGroup;
			addActionWith: [ :action | action
				name: 'Open file location';
				iconName: 'open';
				description: 'Open current file location on the external file manager';
				action: [ self doOpenCurrentFolder ] ] ];
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
PulsarDirectoryView >> doAddFileCommand: aCommand [
	| dialog fileName selectedDir |
	
	selectedDir := self selectedDirectoryModel.

	dialog := self instantiate: PulsarRequestPresenter.
	dialog label: 'File Name'.
	dialog acceptLabel: 'Create'.

	dialog asPopover
		relativeTo: aCommand presenter;
		popupModalAndWait.
	dialog isOk ifFalse: [ ^ self ].

	fileName := dialog text.
	selectedDir createFileNamed: fileName.
	self updatePresenter
]

{ #category : 'private - actions' }
PulsarDirectoryView >> doAddFolderCommand: aCommand [
	| dialog folderName selectedDir |
	
	selectedDir := self selectedDirectoryModel.

	dialog := self instantiate: PulsarRequestPresenter.
	dialog label: 'Folder Name'.
	dialog acceptLabel: 'Create'.

	dialog asPopover
		relativeTo: aCommand presenter;
		popupModalAndWait.
	dialog isOk ifFalse: [ ^ self ].

	folderName := dialog text.
	selectedDir createDirectoryNamed: folderName.
	self updatePresenter
]

{ #category : 'private - actions' }
PulsarDirectoryView >> doClose [

	self withNearWindowLikeDo: [ :aWindow | aWindow close ]
]

{ #category : 'private - actions' }
PulsarDirectoryView >> doOpenCurrentFolder [

	self model entity openInOSFileBrowser
]

{ #category : 'private - actions' }
PulsarDirectoryView >> doRemoveSelectedFileOrFolder [
	"Remove the selected file or folder after user confirmation."
	| okToRemove selected |
	
	selected := listPresenter selectedItem.
	selected ifNil: [ ^ self ].

	okToRemove := self application newConfirm
		title: 'Remove';
		message: ('Do you want to remove {1}?' format: { selected name });
		acceptLabel: 'Remove';
		openModalWithParent: self window.
	okToRemove ifFalse: [ ^ self ].

	selected entity delete.
	self updatePresenter
]

{ #category : 'events' }
PulsarDirectoryView >> eventModelChanged: ann [

	ann value = self model ifFalse: [ ^ self ].
	self updatePresenter
]

{ #category : 'initialization' }
PulsarDirectoryView >> initializePresenters [

	self addStyle: 'pulsarDirectoryView'.

	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.
	toolbarPresenter actions: (self actions actionsForAll: #( actions directory )).
	toolbarPresenter addPresenter: (self newToolbar
		beIcons;
		add: (self newButton
			addStyle: 'flat';
			icon: (self iconNamed: 'close');
			help: 'Close critics console';
			action: [ self doClose ];
			yourself);
		yourself).

	listPresenter := self newEasyTreeListView
		addStyle: 'stTree';
		children: [ :aModel | aModel children ];
		display: [ :aModel | aModel name ];
		displayIcon: [ :aModel | self iconNamed: aModel iconName ];
		actions: (self actions actionsForAll: #( directory directoryCritical ));
		yourself
]

{ #category : 'private' }
PulsarDirectoryView >> panelPlacedIconName [

	^ 'fileManager'
]

{ #category : 'initialization' }
PulsarDirectoryView >> registerToEvents [

	super registerToEvents.
	self announcer when: PulsarModelChanged send: #eventModelChanged: to: self
]

{ #category : 'private - accessing' }
PulsarDirectoryView >> selectedDirectoryModel [
	"Return the selected item if it is a directory model, otherwise return the root model."
	| selected |
	
	selected := listPresenter selectedItem.
	^ (selected isNotNil and: [ selected isDirectory ])
		  ifTrue: [ selected ]
		  ifFalse: [ self model ]
]

{ #category : 'initialization' }
PulsarDirectoryView >> updatePresenter [

	self model ifNil: [ ^ self ].

	listPresenter roots: self model children
]
