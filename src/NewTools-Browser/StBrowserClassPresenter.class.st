Class {
	#name : #StBrowserClassPresenter,
	#superclass : #StBrowserModelPresenter,
	#instVars : [
		'pages',
		'classSidePanel',
		'instanceSidePanel',
		'selectedPage',
		'variablesPanel'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #initialization }
StBrowserClassPresenter >> classSidePanel [

	^ classSidePanel ifNil: [ classSidePanel := self newClassSidePanel ]
]

{ #category : #initialization }
StBrowserClassPresenter >> initializePresenters [

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
StBrowserClassPresenter >> instanceSidePanel [

	^ instanceSidePanel ifNil: [ instanceSidePanel := self newInstanceSidePanel ]
]

{ #category : #initialization }
StBrowserClassPresenter >> newClassSidePanel [
	
	^ self instantiate: StBrowserClassOrganizationPresenter on: self model classSide
]

{ #category : #initialization }
StBrowserClassPresenter >> newInstanceSidePanel [
	
	^ self instantiate: StBrowserClassOrganizationPresenter on: self model
]

{ #category : #initialization }
StBrowserClassPresenter >> newVariablesPanel [

	^ self newLabel label: 'TODO'
]

{ #category : #initialization }
StBrowserClassPresenter >> updatePresenter [ 

	"Start on instance side (unless someone says the opposite)"
	selectedPage 
		ifNotNil: [ pages selectPage: selectedPage ]
		ifNil: [ pages selectPageIndex: 2 ].
		
	instanceSidePanel ifNotNil: [ instanceSidePanel model: (self model ifNotNil: #instanceSide) ].
	classSidePanel ifNotNil: [ classSidePanel model: (self model ifNotNil: #classSide) ].
	"variablesPanel ifNotNil: [ variablesPanel model: (self model ifNotNil: #instanceSide) ]"
]

{ #category : #initialization }
StBrowserClassPresenter >> variablesPanel [

	^ variablesPanel ifNil: [ variablesPanel := self newVariablesPanel ]
]
