"
Shared directory tree behavior for Pulsar directory presenters.

It provides the directory tree widget creation, the directory/file actions (create, remove, open location and terminal), and the model-driven presenter update. Users are expected to provide a listPresenter (through PulsarCollectionView), a model, and to override updateHeaderPresenter when they display a header.
"
Trait {
	#name : 'PulsarTDirectoryTree',
	#category : 'Pulsar-Tool-FileEditor-View',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'View'
}

{ #category : 'private - definitions' }
PulsarTDirectoryTree >> defineActionsOn: aBuilder [
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
PulsarTDirectoryTree >> doAddFileCommand: aCommand [

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
	self listPresenter
		selectItem: reference;
		takeKeyboardFocus
]

{ #category : 'private - actions' }
PulsarTDirectoryTree >> doAddFolderCommand: aCommand [

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
	self listPresenter
		selectItem: reference;
		takeKeyboardFocus
]

{ #category : 'private - actions' }
PulsarTDirectoryTree >> doOpenCurrentFolder [

	self model openInOSFileBrowser
]

{ #category : 'private - actions' }
PulsarTDirectoryTree >> doOpenTerminalOnCurrentFolder [

	self model openTerminal
]

{ #category : 'private - actions' }
PulsarTDirectoryTree >> doRemoveSelectedFileOrFolder [
	"Remove the selected file or folder after user confirmation."

	| okToRemove selected |
	selected := self listPresenter selectedItem.
	selected ifNil: [ ^ self ].

	okToRemove := self application newConfirm
		              title: 'Remove';
		              message: ('Do you want to remove {1}?' format: { selected name });
		              acceptLabel: 'Remove';
		              openModalWithParent: self window.
	okToRemove ifFalse: [ ^ self ].

	selected delete.
	self updatePresenter
]

{ #category : 'events' }
PulsarTDirectoryTree >> eventModelChanged: ann [

	ann value = self model ifFalse: [ ^ self ].
	self updatePresenter
]

{ #category : 'private' }
PulsarTDirectoryTree >> newDirectoryTree [
	"Create the directory tree list used by directory presenters."

	^ self newEasyTreeListView
		  addStyle: 'stTree';
		  children: [ :aModel | aModel children ];
		  display: [ :aModel | aModel name ];
		  displayIcon: [ :aModel | self iconNamed: aModel iconName ];
		  actions: (self actions actionsForAll: #( directory directoryCritical ));
		  yourself
]

{ #category : 'initialization' }
PulsarTDirectoryTree >> registerToEvents [

	super registerToEvents.
	self announcer when: PulsarModelChanged send: #eventModelChanged: to: self
]

{ #category : 'private - accessing' }
PulsarTDirectoryTree >> selectedDirectoryModel [
	"Return the selected item if it is a directory model, otherwise return the root model."

	| selected |
	selected := self listPresenter selectedItem.
	^ (selected isNotNil and: [ selected isDirectory ])
		  ifTrue: [ selected ]
		  ifFalse: [ self model ]
]

{ #category : 'initialization' }
PulsarTDirectoryTree >> updateHeaderPresenter [
	"Presenters with a header should override this to update it with the current model."

	
]

{ #category : 'initialization' }
PulsarTDirectoryTree >> updatePresenter [

	self model ifNil: [ ^ self ].

	self listPresenter roots: self model children.
	self updateHeaderPresenter.
	self model ensureMonitoringDo: [ 
		self updatePresenter ]
]

{ #category : 'private' }
PulsarTDirectoryTree >> windowClosed [

	super windowClosed.
	self model stopMonitoring
]
