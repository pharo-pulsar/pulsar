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
		'deferredActions'
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
StEnvironmentBrowser class >> openOnMethod: aMethod [

	^ (self on: self defaultEnvironment)
		selectMethod: aMethod;
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

{ #category : #'private - deferring' }
StEnvironmentBrowser >> addDeferredAction: aBlock [
	"Deferred actions are one-shot actions, performed after browser is built."

	deferredActions ifNil: [ deferredActions := #() ].
	deferredActions := deferredActions copyWith: aBlock
]

{ #category : #'accessing - selecting' }
StEnvironmentBrowser >> basicConsumePath: aPath [

		| path |
		path := aPath.
		path := self packagesPanel consumePath: path.
		path ifNotEmpty: [ 
			path := self classPanel consumePath: path ]. 
]

{ #category : #'private - accessing' }
StEnvironmentBrowser >> classPanel [
		
	^ classPanel ifNil: [ 
		self initializeClassPanel.
		classPanel ]
]

{ #category : #'accessing - selecting' }
StEnvironmentBrowser >> consumePath: aPath [
	"Opening in a specific place is tricky in the browser, since the actual selection *is not there* 
	 until you click some places (for example, to open a method you select a package, then a class, 
	 then a method.
	 We need to simulate this, by adding a selected path and consuming it when browser is open."

	self executeOrDeferAction: [ 
		self basicConsumePath: aPath ]
]

{ #category : #'private - accessing' }
StEnvironmentBrowser >> editorContainer [

	^ editorContainer ifNil: [ 
		self initializeEditorContainer.
		editorContainer ]
]

{ #category : #'private - deferring' }
StEnvironmentBrowser >> executeOrDeferAction: aBlock [

	self isBuilt 
		ifTrue: [ aBlock value  ]
		ifFalse: [ self addDeferredAction: aBlock ]
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
		yourself).
		
	self whenBuiltDo: [ self processDeferredActions ]
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

{ #category : #'private - deferring' }
StEnvironmentBrowser >> processDeferredActions [

	deferredActions ifNil: [ ^ self ].
	[
		deferredActions do: [ :eachBlock | eachBlock value ] ]
	ensure: [ 
		deferredActions := nil ]
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

	self consumePath: { 
		StPackageModel newPackage: aClass package.
		StPackageTagModel newPackageTag: (aClass package classTagForClass: aClass).
		StClassModel newClass: aClass 
	}
]

{ #category : #'accessing - selecting' }
StEnvironmentBrowser >> selectMethod: aMethod [
	"See #consumePath method."

	self consumePath: { 
		StPackageModel newPackage: aMethod package.
		StPackageTagModel newPackageTag: (aMethod package classTagForClass: aMethod methodClass).
		StClassModel newClass: aMethod methodClass.
		StProtocolModel 
			newClass: aMethod methodClass 
			protocol: (aMethod methodClass organization protocolNamed: aMethod protocol).
		StMethodModel newMethod: aMethod.
	}
]

{ #category : #'accessing - selecting' }
StEnvironmentBrowser >> selectPackage: aPackage [
	"See #consumePath method."
	
	self consumePath: { 
		StPackageModel newPackage: aPackage.
	}
]
