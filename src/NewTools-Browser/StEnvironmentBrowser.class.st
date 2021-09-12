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
		'packagesPanel'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #'instance creation' }
StEnvironmentBrowser class >> on: anEnvironment [

	^ self basicNew
		initializeEnvironment: anEnvironment;
		yourself
]

{ #category : #'instance creation' }
StEnvironmentBrowser class >> open [
	<script>

	^ self openOn: StSystemEnvironment new
]

{ #category : #'instance creation' }
StEnvironmentBrowser class >> openOn: anEnvironment [

	^ (self on: anEnvironment) openWithSpec
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
