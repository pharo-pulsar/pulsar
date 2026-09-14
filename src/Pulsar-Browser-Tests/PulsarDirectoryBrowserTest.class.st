"
""
Tests that the tree of PulsarDirectoryBrowser keeps the branches the user
expanded across model refreshes (e.g. when file monitoring updates the tree).
""
"
Class {
	#name : 'PulsarDirectoryBrowserTest',
	#superclass : 'PulsarBaseViewTest',
	#instVars : [
		'tempDirectory'
	],
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'accessing' }
PulsarDirectoryBrowserTest >> classToTest [
	^ PulsarDirectoryBrowser
]

{ #category : 'helpers' }
PulsarDirectoryBrowserTest >> createFileSystem [
	"Create a small directory tree inside tempDirectory:

	tempDirectory
		├── alpha
		│   ├── nested
		│   └── file1.txt
		├── beta
		└── top.txt"

	(self tempDirectory / 'alpha' / 'nested') ensureCreateDirectory.
	(self tempDirectory / 'alpha' / 'file1.txt') ensureCreateFile.
	(self tempDirectory / 'beta') ensureCreateDirectory.
	(self tempDirectory / 'top.txt') ensureCreateFile
]

{ #category : 'testing' }
PulsarDirectoryBrowserTest >> ensureCloseBrowser [
	browser ifNotNil: [
		browser withWindowDo: [ :aWindow | aWindow close ].
		browser := nil ]
]

{ #category : 'helpers' }
PulsarDirectoryBrowserTest >> openBrowserOn: aFileReference [
	| directoryModel |

	directoryModel := PulsarDirectoryModel
		newEnvironment: (PvEnvironmentModel onSystem)
		entity: aFileReference.

	browser := self application
		instantiate: PulsarDirectoryBrowser
		on: directoryModel.

	browser open.

	^ browser
]

{ #category : 'running' }
PulsarDirectoryBrowserTest >> tearDown [

	tempDirectory ifNotNil: [
		tempDirectory deleteAll.
		tempDirectory := nil ].
		
	super tearDown		
]

{ #category : 'accessing' }
PulsarDirectoryBrowserTest >> tempDirectory [
	^ tempDirectory ifNil: [
		tempDirectory := (FileReference
				newTempFilePrefix: 'PulsarDirectoryBrowserTest'
				suffix: '')
			ensureCreateDirectory ]
]

{ #category : 'tests' }
PulsarDirectoryBrowserTest >> testCollapsedBranchStaysCollapsed [
	| tree |
	self createFileSystem.
	self openBrowserOn: self tempDirectory.

	"refresh as the file monitor would"
	browser updatePresenter.
	self waitForUI.

	tree := browser listPresenter.
	self deny: (tree isExpanded: #(1)).
	self deny: (tree isExpanded: #(2))
]

{ #category : 'tests' }
PulsarDirectoryBrowserTest >> testExpandedBranchSurvivesRefresh [
	| tree |
	self createFileSystem.
	self openBrowserOn: self tempDirectory.

	"expand the first directory (alpha)"
	tree := browser listPresenter.
	tree expandPath: #(1).
	self waitForUI.

	"refresh as the file monitor would"
	browser updatePresenter.
	self waitForUI.

	self assert: (tree isExpanded: #(1)).
	self deny: (tree isExpanded: #(2))
]

{ #category : 'tests' }
PulsarDirectoryBrowserTest >> testSnapshotRemembersExpandedBranches [
	| directoryView tree snapshot directorySnapshot |

	self openBrowser.
	directoryView := (browser presenterWithClass: PulsarDirectoryView) presenter.
	tree := directoryView listPresenter.
	tree expandPath: #(1).
	self waitForUI.
	snapshot := browser snapshot.
	directorySnapshot := snapshot snapshotWithClass: PulsarDirectorySnapshot.
	self assert: directorySnapshot expandedItems asSet equals: directoryView expandedItems
]

{ #category : 'tests' }
PulsarDirectoryBrowserTest >> testSnapshotRestoresExpandedBranches [
	| directoryView tree snapshot restoredBrowser restoredView restoredTree |

	self openBrowser.
	directoryView := (browser presenterWithClass: PulsarDirectoryView) presenter.
	tree := directoryView listPresenter.
	tree expandPath: #(1).
	self waitForUI.
	snapshot := browser snapshot.
	restoredBrowser := snapshot instantiateOn: self application.
	[
		snapshot restoreTo: restoredBrowser.
		restoredBrowser open.
		self waitForUI.
		restoredView := (restoredBrowser presenterWithClass: PulsarDirectoryView) presenter.
		restoredTree := restoredView listPresenter.
		self assert: (restoredTree isExpanded: #(1)) ] ensure: [ restoredBrowser withWindowDo: [ :aWindow | aWindow close ] ]
]

{ #category : 'tests' }
PulsarDirectoryBrowserTest >> testVanishedDirectoryIsPrunedFromExpandedItems [
	| tree |
	self createFileSystem.
	self openBrowserOn: self tempDirectory.

	"expand the first directory (alpha)"
	tree := browser listPresenter.
	tree expandPath: #(1).
	self waitForUI.
	self assert: browser expandedItems isNotEmpty.

	"remove alpha from disk, then refresh"
	(self tempDirectory / 'alpha') deleteAll.
	browser updatePresenter.
	self waitForUI.

	self assert: browser expandedItems isEmpty
]
