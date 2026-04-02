Class {
	#name : 'PulsarRepositoryProjectDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'namePresenter',
		'model',
		'acceptBlock',
		'sourceDirectoryTreePresenter',
		'selectedDirectoryPath',
		'formatPresenter',
		'formats',
		'defaultFormat',
		'messageIconPresenter',
		'messageTextPresenter',
		'removeDirectoryButtonPresenter',
		'addDirectoryButtonPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View-Repositories',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Repositories'
}

{ #category : 'accessing' }
PulsarRepositoryProjectDialog class >> defaultPreferredExtent [

	^ 475@525
]

{ #category : 'actions' }
PulsarRepositoryProjectDialog >> accept [

	(IceTipStandardAction new
		repository: self model repository;
		message: 'Setting up project';
		action: [
			self model sourceDirectory: self selectedDirectoryPath pathString.
			self model fileFormat: self selectedFileFormat.
			self model repositoryProperties fileFormat = self selectedFileFormat
				ifFalse: [ self error: 'Selected file format is incorrect.' ].
			self model repository workingCopy project: self model ];
		yourself)
		executeWithContext: self.

	acceptBlock ifNotNil: [ acceptBlock value: self ].
]

{ #category : 'actions' }
PulsarRepositoryProjectDialog >> addDirectory [
	| newDirectoryName |

	newDirectoryName := self application newRequest
		title: 'Create directory';
		label: 'Directory name';
		text: '';
		acceptLabel: 'Create';
		openModalWithParent: self window.
	newDirectoryName ifNil: [ ^ self ].
	newDirectoryName := newDirectoryName trimBoth.
	newDirectoryName ifEmpty: [ ^ self ].

	self createNewDirectory: newDirectoryName
]

{ #category : 'creation' }
PulsarRepositoryProjectDialog >> createNewDirectory: aString [
	| newDirectory previousSelection |

	previousSelection := selectedDirectoryPath.
	newDirectory := previousSelection / aString asResolvedBy: self model fileSystem.
	newDirectory exists ifTrue: [ ^ self ].
	newDirectory createDirectory.
	sourceDirectoryTreePresenter roots: { self model fileSystem }.
	self expandAndSelect: previousSelection / aString
]

{ #category : 'layout' }
PulsarRepositoryProjectDialog >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		borderWidth: 5;
		spacing: 5;
		add: (SpBoxLayout newLeftToRight
			spacing: 5;
			vAlignCenter;
			add: 'Project name' expand: false;
			add: namePresenter;
			add: addDirectoryButtonPresenter expand: false;
			add: removeDirectoryButtonPresenter expand: false;
			yourself) expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: 5;
			add: 'Code directory' expand: false;
			add: sourceDirectoryTreePresenter;
			yourself);
		add: (SpBoxLayout newLeftToRight
			vAlignCenter;
			spacing: 5;
			add: 'Format' expand: false;
			add: formatPresenter;
			yourself) expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: 5;
			add: messageIconPresenter expand: false;
			add: messageTextPresenter;
			yourself);
		yourself
]

{ #category : 'utilities' }
PulsarRepositoryProjectDialog >> expandAndSelect: aRelativePath [
	| path aPathForSpec currentNode |

	path := aRelativePath segments asOrderedCollection.
	aPathForSpec := OrderedCollection new.
	aPathForSpec add: 1.
	currentNode := self model fileSystem.

	path do: [ :aPart |
		| found visibleDirectories |
		visibleDirectories := currentNode directories reject: [ :dir | dir basename = '.git' ].
		found := visibleDirectories
			detect: [ :each | each basename = aPart ]
			ifNone: [ ^ self ].
		aPathForSpec add: (visibleDirectories indexOf: found) - 1.
		currentNode := found ].

	sourceDirectoryTreePresenter expandPath: aPathForSpec.
	sourceDirectoryTreePresenter withAdapterPerformOrDefer: [ :anAdapter |
		sourceDirectoryTreePresenter selectPaths: { aPathForSpec } ]
]

{ #category : 'accessing - ui' }
PulsarRepositoryProjectDialog >> formatPresenter [

	^ formatPresenter
]

{ #category : 'accessing' }
PulsarRepositoryProjectDialog >> formats [

	^ formats
]

{ #category : 'format-management' }
PulsarRepositoryProjectDialog >> guessFormatFromDirectory: aFileReference [
	| guineaPig |

	aFileReference exists ifFalse: [ ^ defaultFormat ].
	guineaPig := aFileReference children
		detect: [ :any | any isDirectory ]
		ifNone: [ ^ defaultFormat ].

	((formats includes: IceLibgitFiletreeWriter)
		and: [ IceLibgitFiletreeWriter isValidPackage: guineaPig ])
			ifTrue: [ ^ IceLibgitFiletreeWriter ].

	^ formats
		detect: [ :each | each isValidPackage: guineaPig ]
		ifNone: [ defaultFormat ]
]

{ #category : 'accessing' }
PulsarRepositoryProjectDialog >> hasToShowWarning [

	^ self model repository workingCopy packages isNotEmpty
]

{ #category : 'initialization' }
PulsarRepositoryProjectDialog >> initialize [

	selectedDirectoryPath := RelativePath new.
	formats := TIceRepositoryWriter users sorted: [ :a :b | a description < b description ].
	defaultFormat := IceLibgitRepository defaultFileFormat.
	super initialize
]

{ #category : 'initialization' }
PulsarRepositoryProjectDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: 'Cancel' do: [ :presenter |
			presenter triggerCancelAction.
			presenter close ];
		addDefaultButton: 'Save' do: [ :presenter |
			self accept.
			presenter triggerOkAction.
			presenter beOk;
			close ]
]

{ #category : 'initialization' }
PulsarRepositoryProjectDialog >> initializeDirectoryTree [

	sourceDirectoryTreePresenter
		addColumn: (SpCompositeTableColumn new
			addColumn: (SpImageTableColumn new
				width: 20;
				evaluated: [ self iconNamed: #folder ];
				yourself);
			addColumn: (SpStringTableColumn new
				evaluated: #basename;
				yourself));
		roots: { self model fileSystem };
		children: [ :each | each directories reject: [ :dir | dir basename = '.git' ] ];
		whenSelectionChangedDo: [ :announcement |
			self sourceDirectorySelectionChanged: announcement selectedPaths ]
]

{ #category : 'initialization' }
PulsarRepositoryProjectDialog >> initializeMessagePanel [
	| icon |

	self hasToShowWarning ifFalse: [ ^ self ].

	icon := self iconNamed: #warning.
	messageIconPresenter image: icon.
	messageTextPresenter text: self warningMessage
]

{ #category : 'initialization' }
PulsarRepositoryProjectDialog >> initializePresenters [

	self addStyle: 'pulsarDialog'.

	namePresenter := self newLabel.
	sourceDirectoryTreePresenter := self newTreeTable
		hideColumnHeaders;
		yourself.
	formatPresenter := self newDropList.
	messageIconPresenter := self newImage.
	messageTextPresenter := self newText
		beNotEditable;
		addStyle: 'iceTipReadonly';
		yourself.

	removeDirectoryButtonPresenter := self newButton
		addStyle: 'small';
		icon: (self iconNamed: #remove);
		action: [ self removeDirectory ];
		yourself.
	addDirectoryButtonPresenter := self newButton
		addStyle: 'small';
		icon: (self iconNamed: #add);
		action: [ self addDirectory ];
		yourself.

	self initializeMessagePanel.
	self initializeDirectoryTree
]

{ #category : 'initialization' }
PulsarRepositoryProjectDialog >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Edit Repository Project';
		initialExtent: self class defaultPreferredExtent
]

{ #category : 'accessing' }
PulsarRepositoryProjectDialog >> model [

	^ model
]

{ #category : 'accessing' }
PulsarRepositoryProjectDialog >> onAccept: aBlock [

	acceptBlock := aBlock.
	^ self
]

{ #category : 'actions' }
PulsarRepositoryProjectDialog >> removeDirectory [
	| toRemove newSelection |

	newSelection := selectedDirectoryPath parent.
	toRemove := selectedDirectoryPath asResolvedBy: self model fileSystem.

	toRemove exists ifFalse: [ ^ self ].
	(self application newConfirm
		title: 'Remove directory';
		message: ('Delete ''{1}''?' format: { toRemove basename });
		acceptLabel: 'Delete';
		openModalWithParent: self window)
			ifFalse: [ ^ self ].

	toRemove ensureDelete.
	sourceDirectoryTreePresenter roots: { self model fileSystem }.
	self expandAndSelect: newSelection
]

{ #category : 'accessing - ui' }
PulsarRepositoryProjectDialog >> selectedDirectoryPath [

	^ selectedDirectoryPath
]

{ #category : 'actions' }
PulsarRepositoryProjectDialog >> selectedFileFormat [

	^ formatPresenter selectedItem
]

{ #category : 'events' }
PulsarRepositoryProjectDialog >> setModelBeforeInitialization: anObject [

	model := anObject
]

{ #category : 'accessing' }
PulsarRepositoryProjectDialog >> sourceDirectorySelectionChanged: selectedPaths [
	| selection |

	selectedPaths
		ifEmpty: [
			selectedDirectoryPath := RelativePath new.
			selection := self sourceDirectoryTreePresenter roots first ]
		ifNotEmpty: [ selection := self sourceDirectoryTreePresenter itemAtPath: selectedPaths first ].

	formatPresenter selectItem: (self guessFormatFromDirectory: selection).
	selectedDirectoryPath := selection relativeTo: self model fileSystem
]

{ #category : 'accessing - ui' }
PulsarRepositoryProjectDialog >> sourceDirectoryTreePresenter [

	^ sourceDirectoryTreePresenter
]

{ #category : 'initialization' }
PulsarRepositoryProjectDialog >> updatePresenter [
	| sourceDirectory |

	namePresenter label: self model name.
	formatPresenter
		items: self formats;
		display: [ :each | each description ];
		selectItem: (self guessFormatFromDirectory: self model sourceDirectoryReference).

	sourceDirectory := self model sourceDirectoryReference
		ifNil: [ RelativePath new ]
		ifNotNil: [ self model sourceDirectoryReference relativeTo: self model fileSystem ].
	selectedDirectoryPath := sourceDirectory.
	sourceDirectory isEmpty ifFalse: [ self expandAndSelect: sourceDirectory ]
]

{ #category : 'accessing' }
PulsarRepositoryProjectDialog >> warningMessage [

	^ 'Be careful. You should choose the actual format of the current repository.
Changing the format here will not migrate your code to another format.

If you want to migrate your code between formats, use a dedicated repository migration workflow.'
]
