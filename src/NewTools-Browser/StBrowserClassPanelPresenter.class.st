Class {
	#name : #StBrowserClassPanelPresenter,
	#superclass : #StBrowserPanelPresenter,
	#instVars : [
		'pages',
		'classSidePanel',
		'instanceSidePanel',
		'selectedPage',
		'variablesPanel',
		'methodSelectionChangedBlock',
		'protocolSelectionChangedBlock'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #initialization }
StBrowserClassPanelPresenter >> classSidePanel [

	^ classSidePanel ifNil: [
		self initializeClassSidePanel.
		classSidePanel ]
]

{ #category : #'accessing - selecting' }
StBrowserClassPanelPresenter >> consumePath: aPath [

	^ aPath second isInstanceSide 
		ifTrue: [ 
			self selectInstanceSide.
			self instanceSidePanel consumePath: aPath ]
		ifFalse: [ 
			self selectClassSide. 
			self classSidePanel consumePath: aPath ]
]

{ #category : #transmission }
StBrowserClassPanelPresenter >> defaultOutputPort [

	^ self outputMethodSelectionPort
]

{ #category : #initialization }
StBrowserClassPanelPresenter >> initializeClassSidePanel [
	
	classSidePanel := self instantiate: StBrowserClassOrganizationPresenter on: self model classSide.
	classSidePanel whenMethodSelectionChangedDo: [ :selection | 
		self methodSelectionChanged: selection ].
	classSidePanel whenProtocolSelectionChangedDo: [ :selection | 
		self protocolSelectionChanged: selection ]
]

{ #category : #initialization }
StBrowserClassPanelPresenter >> initializeInstanceSidePanel [
	
	instanceSidePanel := self instantiate: StBrowserClassOrganizationPresenter on: self model.
	instanceSidePanel whenMethodSelectionChangedDo: [ :selection | 
		self methodSelectionChanged: selection ].
	instanceSidePanel whenProtocolSelectionChangedDo: [ :selection | 
		self protocolSelectionChanged: selection ]
]

{ #category : #initialization }
StBrowserClassPanelPresenter >> initializePresenters [

	self layout: (SpBoxLayout newVertical
		add: (pages := self newNotebook);
		yourself).
		
	pages 
		addPageTitle: 'Class' provider: [ self classSidePanel ];
		addPageTitle: 'Instance' provider: [ self instanceSidePanel ];
		addPageTitle: 'Variables' provider: [ self variablesPanel ];
		whenSelectedPageChangedDo: [ :newValue | selectedPage := newValue ]
]

{ #category : #initialization }
StBrowserClassPanelPresenter >> initializeVariablesPanel [
	
	variablesPanel := self newLabel label: 'TODO'
]

{ #category : #initialization }
StBrowserClassPanelPresenter >> instanceSidePanel [

	^ instanceSidePanel ifNil: [ 
		self initializeInstanceSidePanel.
		instanceSidePanel ]
]

{ #category : #private }
StBrowserClassPanelPresenter >> methodSelectionChanged: aSelection [
	
	methodSelectionChangedBlock ifNil: [ ^ self ].
	methodSelectionChangedBlock cull: aSelection
]

{ #category : #transmission }
StBrowserClassPanelPresenter >> outputMethodSelectionPort [

	^ SpSelectorSelectionPort 
		newPresenter: self
		selector: #whenMethodSelectionChangedDo:
]

{ #category : #transmission }
StBrowserClassPanelPresenter >> outputProtocolSelectionPort [

	^ SpSelectorSelectionPort 
		newPresenter: self
		selector: #whenProtocolSelectionChangedDo:
]

{ #category : #private }
StBrowserClassPanelPresenter >> protocolSelectionChanged: aSelection [
	
	protocolSelectionChangedBlock ifNil: [ ^ self ].
	protocolSelectionChangedBlock cull: aSelection
]

{ #category : #'accessing - selecting' }
StBrowserClassPanelPresenter >> selectClassSide [
	
	pages selectedPageIndex = 1 ifTrue: [ ^ self ].
	pages selectPageIndex: 1 
]

{ #category : #'accessing - selecting' }
StBrowserClassPanelPresenter >> selectInstanceSide [
	
	pages selectedPageIndex = 2 ifTrue: [ ^ self ].
	pages selectPageIndex: 2
]

{ #category : #'accessing - selecting' }
StBrowserClassPanelPresenter >> selectVariablesSide [
	
	pages selectedPageIndex = 3 ifTrue: [ ^ self ].
	pages selectPageIndex: 3
]

{ #category : #initialization }
StBrowserClassPanelPresenter >> updatePresenter [ 

	"Start on instance side (unless someone says the opposite)"
	selectedPage 
		ifNotNil: [ pages selectPage: selectedPage ]
		ifNil: [ pages selectPageIndex: 2 ].
		
	instanceSidePanel ifNotNil: [ instanceSidePanel model: (self model ifNotNil: #instanceSide) ].
	classSidePanel ifNotNil: [ classSidePanel model: (self model ifNotNil: #classSide) ].
	"variablesPanel ifNotNil: [ variablesPanel model: (self model ifNotNil: #instanceSide) ]"
]

{ #category : #initialization }
StBrowserClassPanelPresenter >> variablesPanel [

	^ variablesPanel ifNil: [ 
		self initializeVariablesPanel.
		variablesPanel ]
]

{ #category : #events }
StBrowserClassPanelPresenter >> whenMethodSelectionChangedDo: aBlock [

	methodSelectionChangedBlock := aBlock
]

{ #category : #events }
StBrowserClassPanelPresenter >> whenProtocolSelectionChangedDo: aBlock [

	protocolSelectionChangedBlock := aBlock
]
