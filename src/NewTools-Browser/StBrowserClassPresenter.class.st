Class {
	#name : #StBrowserClassPresenter,
	#superclass : #StBrowserModelPresenter,
	#instVars : [
		'pages',
		'classSidePanel',
		'instanceSidePanel',
		'selectedPage'
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
		whenSelectedPageChangedDo: [ :newValue | selectedPage := newValue ]
]

{ #category : #initialization }
StBrowserClassPresenter >> instanceSidePanel [

	^ instanceSidePanel ifNil: [ instanceSidePanel := self newInstanceSidePanel ]
]

{ #category : #initialization }
StBrowserClassPresenter >> newClassSidePanel [
	
	^ self instantiate: StBrowserClassOrganizationPresenter
]

{ #category : #initialization }
StBrowserClassPresenter >> newInstanceSidePanel [
	
	^ self instantiate: StBrowserClassOrganizationPresenter
]

{ #category : #initialization }
StBrowserClassPresenter >> updatePresenter [ 

	"Start on instance side (unless someone says the opposite)"
	selectedPage 
		ifNotNil: [ pages selectPage: selectedPage ]
		ifNil: [ pages selectPageIndex: 2 ].
		
	instanceSidePanel ifNotNil: [ instanceSidePanel model: self model ].
	classSidePanel ifNotNil: [ classSidePanel model: self model ]
]
