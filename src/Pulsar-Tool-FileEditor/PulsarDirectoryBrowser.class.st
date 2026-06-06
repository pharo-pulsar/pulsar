"
A combined directory browser showing a tree list of directories and files on the left, with a file editor on the right.

It follows the same pattern as PulsarMessageBrowser: a header toolbar, a list/tree, and a content editor. Clicking a file in the tree opens it in the embedded PulsarFileEditor. The model is a PulsarDirectoryModel wrapping a root directory FileReference.
"
Class {
	#name : 'PulsarDirectoryBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTSnapshot',
	#classTraits : 'SpTModel classTrait + PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTSnapshot classTrait',
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

{ #category : 'initialization' }
PulsarDirectoryBrowser >> initializePresenters [

	self addStyle: 'pulsarDirectoryBrowser'.

	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.

	directoryTreePresenter := self newEasyTreeListView
		                          addStyle: 'stTree';
		                          children: [ :aModel | aModel children ];
		                          display: [ :aModel | aModel name ];
		                          displayIcon: [ :aModel | self iconNamed: aModel iconName ];
		                          yourself.

	editorPresenter := self instantiate: PulsarFileEditor
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

{ #category : 'accessing - model' }
PulsarDirectoryBrowser >> setModelBeforeInitialization: aModel [

	model := aModel
]

{ #category : 'accessing - snapshot' }
PulsarDirectoryBrowser >> snapshot [

	^ PulsarPresenterWithModelSnapshot on: self
]

{ #category : 'initialization' }
PulsarDirectoryBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].

	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | aBreadcrumb addSegment: self model fullName ].
	directoryTreePresenter roots: self model children
]
