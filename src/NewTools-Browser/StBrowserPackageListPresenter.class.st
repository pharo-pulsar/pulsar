Class {
	#name : #StBrowserPackageListPresenter,
	#superclass : #StBrowserPanelPresenter,
	#instVars : [
		'packagesTreePresenter',
		'classesPanelPresenter'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #transmission }
StBrowserPackageListPresenter >> defaultInputPort [

	^ self outputClassSelectionPort
]

{ #category : #transmission }
StBrowserPackageListPresenter >> defaultOutputPort [

	^ self outputClassSelectionPort
]

{ #category : #private }
StBrowserPackageListPresenter >> iconForPackage: aClass [
		
	^ nil
]

{ #category : #initialization }
StBrowserPackageListPresenter >> initializePresenters [

	self layout: (SpPanedLayout newLeftToRight
		add: (packagesTreePresenter := self newTree);
		add: (classesPanelPresenter := self instantiate: StBrowserClassListPresenter);
		yourself).
		
	packagesTreePresenter 
		display: [ :aPackage | self nameForPackage: aPackage ];
		displayIcon: [ :aPackage | self iconForPackage: aPackage ];
		children: [ :aPackage | self childrenOf: aPackage ].
	
	packagesTreePresenter 
		transmitTo: classesPanelPresenter
		transform: [ :aPackageOrTag | self classesOf: aPackageOrTag ]
]

{ #category : #private }
StBrowserPackageListPresenter >> nameForPackage: aPackage [
		
	^ aPackage browserName
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
