Class {
	#name : #StBrowserPackageListPresenter,
	#superclass : #StBrowserPanelPresenter,
	#instVars : [
		'packagesTreePresenter',
		'classesPanelPresenter'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #private }
StBrowserPackageListPresenter >> classesOf: aPackageTagModel [
	
	aPackageTagModel ifNil: [ ^ #() ].
	^ aPackageTagModel classes
]

{ #category : #'private - accessing' }
StBrowserPackageListPresenter >> classesPanel [

	^ classesPanelPresenter
]

{ #category : #'private - consuming' }
StBrowserPackageListPresenter >> consumeClassFromPath: path [
	
	path ifEmpty: [ ^ #() ].
	
	classesPanelPresenter selectItem: path first. 
	^ path allButFirst
]

{ #category : #'private - consuming' }
StBrowserPackageListPresenter >> consumePackageFromPath: path [
	"receives a path #(package), #(package tag ...) 
	 It contains a package alone or a package with a tag (and probably more, like a class)"
	
	path ifEmpty: [ ^ #() ].
	
	"I received a simple package"
	path size = 1 ifTrue: [ 
		packagesTreePresenter selectPathByItems: path scrollToSelection: true.
		^ #() ].
	
	"I received a pachage and a tag"
	path second isRoot 
		ifTrue: [ packagesTreePresenter selectPathByItems: { path first } scrollToSelection: true ]
		ifFalse: [ packagesTreePresenter selectPathByItems: (path first: 2) scrollToSelection: true ].
	
	^ path allButFirst: 2
]

{ #category : #'accessing - selecting' }
StBrowserPackageListPresenter >> consumePath: anArray [
	| path |

	path := anArray.
	path := self consumePackageFromPath: path.
	path := self consumeClassFromPath: path.
	
	^ path
]

{ #category : #transmission }
StBrowserPackageListPresenter >> defaultInputPort [

	^ self outputClassSelectionPort
]

{ #category : #transmission }
StBrowserPackageListPresenter >> defaultOutputPort [

	^ self outputClassSelectionPort
]

{ #category : #initialization }
StBrowserPackageListPresenter >> initializePresenters [

	self layout: (SpPanedLayout newLeftToRight
		add: (packagesTreePresenter := self newTree);
		add: (classesPanelPresenter := self instantiate: StBrowserClassListPresenter);
		yourself).
		
	packagesTreePresenter 
		display: [ :aPackageModel | aPackageModel name ];
		displayIcon: [ :aPackageModel | self iconNamed: aPackageModel iconName ];
		displayColor: [ :aPackageModel | self colorNamed: aPackageModel colorName ];
		children: [ :aPackageModel | aPackageModel children ].
	
	packagesTreePresenter 
		transmitTo: classesPanelPresenter
		transform: [ :aPackageOrTag | self classesOf: aPackageOrTag ]
]

{ #category : #transmission }
StBrowserPackageListPresenter >> outputClassSelectionPort [

	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ classesPanelPresenter outputClassSelectionPort ];
		yourself
]

{ #category : #transmission }
StBrowserPackageListPresenter >> outputPackageSelectionPort [

	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ packagesTreePresenter ];
		yourself
]

{ #category : #'private - accessing' }
StBrowserPackageListPresenter >> packagesTree [
	
	^ packagesTreePresenter
]

{ #category : #initialization }
StBrowserPackageListPresenter >> updatePresenter [

	packagesTreePresenter roots: self model packages
]

{ #category : #events }
StBrowserPackageListPresenter >> whenClassSelectionChangedDo: aBlock [

	classesPanelPresenter whenSelectionChangedDo: aBlock
]

{ #category : #events }
StBrowserPackageListPresenter >> whenPackageSelectionChangedDo: aBlock [

	packagesTreePresenter whenSelectionChangedDo: aBlock
]
