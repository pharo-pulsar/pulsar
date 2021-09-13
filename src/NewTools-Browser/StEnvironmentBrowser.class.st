Class {
	#name : #StEnvironmentBrowser,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'projectsPresenter',
		'classPanel',
		'editorContainer',
		'hierarchyPanel',
		'packagesPanel',
		'selectedPath'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StEnvironmentBrowser class >> defaultEnvironment [

	^ StSystemEnvironment new
]

{ #category : #'instance creation' }
StEnvironmentBrowser class >> on: anEnvironment [

	^ self basicNew
		initializeEnvironment: anEnvironment;
		yourself
]

{ #category : #opening }
StEnvironmentBrowser class >> open [
	<script>

	^ self openOn: self defaultEnvironment
]

{ #category : #opening }
StEnvironmentBrowser class >> openOn: anEnvironment [

	^ (self on: anEnvironment) openWithSpec
]

{ #category : #opening }
StEnvironmentBrowser class >> openOnClass: aClass [

	^ (self on: self defaultEnvironment)
		selectClass: aClass;
		openWithSpec
]

{ #category : #opening }
StEnvironmentBrowser class >> openOnPackage: aPackage [

	^ (self on: self defaultEnvironment)
		selectPackage: aPackage;
		openWithSpec
]

{ #category : #accessing }
StEnvironmentBrowser class >> preferredExtent [

	^ 900@650
]

{ #category : #'private - accessing' }
StEnvironmentBrowser >> classPanel [
		
	^ classPanel ifNil: [ 
		self initializeClassPanel.
		classPanel ]
]

{ #category : #private }
StEnvironmentBrowser >> consumePath [
	"Opening in a speciphic place is tricky in the browser, since the actual selection *is not there* 
	 until you click some places (for example, to open a method you select a package, then a class, 
	 then a method.
	 We need to simulte this, by adding a selected path and consuming it when browser is open."

	selectedPath := packagesPanel consumePath: selectedPath.
	selectedPath := nil
]

{ #category : #'private - accessing' }
StEnvironmentBrowser >> editorContainer [

	^ editorContainer ifNil: [ 
		self initializeEditorContainer.
		editorContainer ]
]

{ #category : #'private - accessing' }
StEnvironmentBrowser >> hierarchyPanel [
		
	^ hierarchyPanel ifNil: [ 
		self initializeHierarchyPanel.
		hierarchyPanel ]
]

{ #category : #initialization }
StEnvironmentBrowser >> initializeClassPanel [

	classPanel := self instantiate: StBrowserClassPanelPresenter.
	classPanel outputProtocolSelectionPort 
		transmitDo: [ :aProtocolModel | "select a method template. Change method template category?" ].
	classPanel 
		transmitDo: [ :aMethodModel | self pushMethodEditor: aMethodModel ]
		
]

{ #category : #initialization }
StEnvironmentBrowser >> initializeEditorContainer [

	editorContainer := self instantiate: StBrowserEditorContainerPresenter
]

{ #category : #initialization }
StEnvironmentBrowser >> initializeEnvironment: anEnvironment [

	model := StEnvironmentBrowserModel on: anEnvironment.
	self initialize
]

{ #category : #initialization }
StEnvironmentBrowser >> initializeHierarchyPanel [

	self flag: #TODO.
	hierarchyPanel := self newList
]

{ #category : #initialization }
StEnvironmentBrowser >> initializePackagesPanel [
	
	packagesPanel := self instantiate: StBrowserPackageListPresenter on: self model.
	packagesPanel outputPackageSelectionPort 
		transmitDo: [ :aPackageModel | "push a package editor + a class template" ].
	packagesPanel transmitTo: self classPanel.
	packagesPanel 
		transmitDo: [ :aClassModel | "push a class comment + a class editor + a method template" ].
	
]

{ #category : #initialization }
StEnvironmentBrowser >> initializePresenters [

	self layout: (SpPanedLayout newTopToBottom
		positionOfSlider: 45 percent;
		add: (SpPanedLayout newLeftToRight
			add: (self newNotebook
				addPageTitle: 'Packages' provider: [ self packagesPanel ];
				addPageTitle: 'Hierarchy' provider: [ self hierarchyPanel ];
				yourself);
			add: self classPanel;
			yourself);
		add: self editorContainer;
		yourself)
]

{ #category : #initialization }
StEnvironmentBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Browser';
		initialExtent: self class preferredExtent
]

{ #category : #'private - accessing' }
StEnvironmentBrowser >> packagesPanel [

	^ packagesPanel ifNil: [ 
		self initializePackagesPanel.
		packagesPanel ]
]

{ #category : #private }
StEnvironmentBrowser >> pushMethodEditor: aMethodModel [

	aMethodModel ifNil: [ 
		self editorContainer removeEditorsMatching: [ :each | each isMethodEditor ].
		^ self ].
	self editorContainer pushEditors: (aMethodModel newEditors)
]

{ #category : #'accessing - selecting' }
StEnvironmentBrowser >> selectClass: aClass [
	"See #consumePath method."

	selectedPath := { 
		StPackageModel newPackage: aClass package.
		StPackageTagModel newPackageTag: (aClass package classTagForClass: aClass).
		StClassModel newClass: aClass 
	}
]

{ #category : #'accessing - selecting' }
StEnvironmentBrowser >> selectPackage: aPackage [
	"See #consumePath method."
	
	selectedPath := { 
		StPackageModel newPackage: aPackage.
	}
]

{ #category : #initialization }
StEnvironmentBrowser >> updatePresenter [

	selectedPath ifNotNil: [ self consumePath ]
]
