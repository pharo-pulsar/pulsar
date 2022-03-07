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
		'deferredActions',
		'selection'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StEnvironmentBrowser class >> defaultEnvironment [

	^ StSystemEnvironment new
]

{ #category : #accessing }
StEnvironmentBrowser class >> defaultTitle [

	^ 'Browser'
]

{ #category : #'instance creation' }
StEnvironmentBrowser class >> new [

	^ self on: self defaultEnvironment
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

	^ (self on: anEnvironment) open
]

{ #category : #opening }
StEnvironmentBrowser class >> openOnClass: aClass [

	^ (self on: self defaultEnvironment)
		  selectClass: aClass;
		  open
]

{ #category : #opening }
StEnvironmentBrowser class >> openOnClass: aClass selector: aSymbol [

	^ (aClass lookupSelector: aSymbol)
		ifNotNil: [ :aMethod | self openOnMethod: aMethod ]
		ifNil: [ self openOnClass: aClass ]
]

{ #category : #opening }
StEnvironmentBrowser class >> openOnMethod: aMethod [

	^ (self on: self defaultEnvironment)
		  selectMethod: aMethod;
		  open
]

{ #category : #opening }
StEnvironmentBrowser class >> openOnPackage: aPackage [

	^ (self on: self defaultEnvironment)
		  selectPackage: aPackage;
		  open
]

{ #category : #accessing }
StEnvironmentBrowser class >> preferredExtent [

	^ 900@650
]

{ #category : #accessing }
StEnvironmentBrowser >> activeEditor [
	
	^ editorContainer activeEditor
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
		path := self classPanel consumePath: path ]
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
		"I am defering the execution because when I have many UI operations, 
		 better executing them all together in one single cycle (otherwise it can 
		 look not smooth)"
		self application defer: [  
			self basicConsumePath: aPath ] ]
]

{ #category : #private }
StEnvironmentBrowser >> editorActivated: anEditor [

	self updateTitle: (anEditor 
		ifNotNil: [ anEditor windowTitle ]
		ifNil: [ self class defaultTitle ])
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
		transmitDo: [ :aProtocolModel | self selectProtocolFromTransmission: aProtocolModel ].
	classPanel 
		transmitDo: [ :aMethodModel | self selectMethodFromTransmission: aMethodModel ]
]

{ #category : #initialization }
StEnvironmentBrowser >> initializeEditorContainer [

	editorContainer := self instantiate: StBrowserEditorContainerPresenter.
	editorContainer whenEditorChangedDo: [ :editor | self editorActivated: editor ]
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
		transmitDo: [ :aPackageModel | self selectPackageFromTransmission: aPackageModel ].
	packagesPanel transmitTo: self classPanel.
	packagesPanel 
		transmitDo: [ :aClassModel | self selectClassFromTransmission: aClassModel ]
]

{ #category : #initialization }
StEnvironmentBrowser >> initializePresenters [

	self layout: self newLayout.
	self whenBuiltDo: [ self processDeferredActions ]
]

{ #category : #initialization }
StEnvironmentBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		initialExtent: self class preferredExtent
]

{ #category : #initialization }
StEnvironmentBrowser >> newLayout [
	
	^ SpPanedLayout newTopToBottom
		positionOfSlider: 40 percent;
		add: (SpPanedLayout newLeftToRight
			add: (self newNotebook
				addPageTitle: 'Packages' provider: [ self packagesPanel ];
				addPageTitle: 'Hierarchy' provider: [ self hierarchyPanel ];
				yourself);
			add: self classPanel;
			yourself);
		add: self editorContainer;
		yourself
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

{ #category : #'private - selecting' }
StEnvironmentBrowser >> select: aModel ifNil: aBlock [

	selection := aModel.

	aModel ifNil: [ 
		aBlock value.
		^ self ].
	
	self editorContainer pushAssociatedEditors: aModel associatedEditors
]

{ #category : #'private - selecting' }
StEnvironmentBrowser >> select: aModel ifNilRemoveEditorsMatching: aBlock [

	self 
		select: aModel 
		ifNil: [ self editorContainer removeEditorsMatching: aBlock ]
]

{ #category : #'accessing - selecting' }
StEnvironmentBrowser >> selectClass: aClass [
	"See #consumePath method."

	self consumePath: { 
		StPackageModel newPackage: aClass instanceSide package.
		StPackageTagModel newPackageTag: (aClass instanceSide package classTagForClass: aClass instanceSide).
		StClassModel newClass: aClass instanceSide
	}
]

{ #category : #'private - selecting' }
StEnvironmentBrowser >> selectClassFromTransmission: aClassModel [

	self 
		select: aClassModel 
		ifNilRemoveEditorsMatching: [ :each | each isClassEditor ]
]

{ #category : #'accessing - selecting' }
StEnvironmentBrowser >> selectMethod: aMethod [
	"See #consumePath method."

	self consumePath: { 
		StPackageModel newPackage: aMethod package.
		StPackageTagModel newPackageTag: (aMethod package classTagForClass: aMethod methodClass instanceSide).
		StClassModel newClass: aMethod methodClass instanceSide.
		StProtocolModel 
			newClass: aMethod methodClass
			protocol: (aMethod methodClass organization protocolNamed: aMethod protocol).
		StMethodModel newMethod: aMethod.
	}
]

{ #category : #'private - selecting' }
StEnvironmentBrowser >> selectMethodFromTransmission: aMethodModel [

	self 
		select: aMethodModel
		ifNilRemoveEditorsMatching: [ :each | each isMethodEditor ]
]

{ #category : #'accessing - selecting' }
StEnvironmentBrowser >> selectPackage: aPackage [
	"See #consumePath method."
	
	self consumePath: { 
		StPackageModel newPackage: aPackage.
	}
]

{ #category : #'private - selecting' }
StEnvironmentBrowser >> selectPackageFromTransmission: aPackageModel [

	self
		select: aPackageModel
		ifNilRemoveEditorsMatching: [ :each | each isPackageEditor ]
]

{ #category : #'private - selecting' }
StEnvironmentBrowser >> selectProtocolFromTransmission: aProtocolModel [
		
	self 
		select: aProtocolModel
		ifNilRemoveEditorsMatching: [ :each | each isMethodEditor ]
]

{ #category : #accessing }
StEnvironmentBrowser >> selection [
	"answer current selected model element.
	 It can be nil, otherwise is an instance of StBaseModel"

	^ selection
]

{ #category : #private }
StEnvironmentBrowser >> updateTitle: aString [

	self withWindowDo: [ :aWindow | aWindow title: aString ]
]
