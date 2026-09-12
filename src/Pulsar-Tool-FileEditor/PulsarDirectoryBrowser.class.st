"
A combined directory browser showing a tree list of directories and files on the left, with a breadcrumb header on top.

It is built on PulsarCollectionView (through PulsarBaseView) and shares the directory tree behavior with PulsarDirectoryView through the PulsarTDirectoryTree trait. Clicking a file in the tree opens it in the embedded PulsarFileEditor. The model is a PulsarDirectoryModel wrapping a root directory FileReference.
"
Class {
	#name : 'PulsarDirectoryBrowser',
	#superclass : 'PulsarCollectionView',
	#traits : 'PulsarTEditor + PulsarTDirectoryTree',
	#classTraits : 'PulsarTEditor classTrait + PulsarTDirectoryTree classTrait',
	#instVars : [
		'headerPresenter'
	],
	#category : 'Pulsar-Tool-FileEditor-View',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'View'
}

{ #category : 'layout' }
PulsarDirectoryBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: headerPresenter expand: false;
		  add: (SpPanedLayout newHorizontal
				   add: listPresenter;
				   yourself);
		  yourself
]

{ #category : 'private - actions' }
PulsarDirectoryBrowser >> doCopyToClipboard [

	self model ifNil: [ ^ self ].
	self application copyToClipboard: self model fullName.
	self withWindowDo: [ :w | w inform: 'Copied to clipboard' ]
]

{ #category : 'private - announcing' }
PulsarDirectoryBrowser >> entityActivated: anEntity [

	self withPopoverDo: [ :aPopover | aPopover dismiss ].
	super entityActivated: anEntity
]

{ #category : 'initialization' }
PulsarDirectoryBrowser >> initializePresenters [

	self addStyle: 'pulsarDirectoryBrowser'.

	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	headerPresenter actions: (self actions actionsFor: #actions).

	headerPresenter addPresenter: (self newToolbar
		beIcons;
		fillWith: (self actions actionsFor: #directory)).

	listPresenter := self newDirectoryTree
]

{ #category : 'private - announcing' }
PulsarDirectoryBrowser >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	anEntity canBeActivated ifFalse: [ ^ self ].
	
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private - notifying' }
PulsarDirectoryBrowser >> notifyEditorClosed [

	super notifyEditorClosed.
	self windowClosed
]

{ #category : 'private' }
PulsarDirectoryBrowser >> panelFocused [

	super panelFocused.
	self takeKeyboardFocus
]

{ #category : 'accessing' }
PulsarDirectoryBrowser >> panelPlacedIconName [

	^ #folder
]

{ #category : 'accessing - snapshot' }
PulsarDirectoryBrowser >> snapshot [

	^ PulsarDirectorySnapshot on: self
]

{ #category : 'initialization' }
PulsarDirectoryBrowser >> updateHeaderPresenter [

	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb |
			aBreadcrumb
				addSegment: self model fullName;
				addButtonSegment: 'copy-to-clipboard'
				help: (f'Copy [self model fullName] to the clipboard')
				action: [ self doCopyToClipboard ] ]
]

{ #category : 'private' }
PulsarDirectoryBrowser >> windowClosed [

	logger trace.

	super windowClosed.
	self model stopMonitoring
]
