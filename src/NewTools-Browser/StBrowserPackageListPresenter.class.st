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

{ #category : #'private - consuming' }
StBrowserPackageListPresenter >> consumePackageFromPath: path [
	"receives a path #(package), #(package tag ...) 
	 It contains a package alone or a package with a tag (and probably more, like a class)"
	
	path ifEmpty: [ ^ #() ].
	
	"I received a simple package"
	path size = 1 ifTrue: [ 
		packagesTreePresenter selectPath: path.
		^ #() ].
	
	"I received a pachage and a tag"
	packagesTreePresenter selectPath: (path first: 2).
	^ path allButFirst: 2
]

{ #category : #'private - consuming' }
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
