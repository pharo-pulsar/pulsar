Class {
	#name : #StBrowserPackagesPresenter,
	#superclass : #StBrowserPanelPresenter,
	#instVars : [
		'classesTreePresenter',
		'packagesTreePresenter'
	],
	#category : #'NewTools-Browser'
}

{ #category : #private }
StBrowserPackagesPresenter >> iconForClass: aClass [
		
	^ nil
]

{ #category : #private }
StBrowserPackagesPresenter >> iconForPackage: aClass [
		
	^ nil
]

{ #category : #initialization }
StBrowserPackagesPresenter >> initializePresenters [

	self layout: (SpPanedLayout newLeftToRight
		add: (packagesTreePresenter := self newTree);
		add: (classesTreePresenter := self newTree);
		yourself).
		
	packagesTreePresenter 
		display: [ :aPackage | self nameForPackage: aPackage ];
		displayIcon: [ :aPackage | self iconForPackage: aPackage ];
		children: [ :aPackage | self childrenOf: aPackage ].
	classesTreePresenter 
		display: [ :aClass | self nameForClass: aClass ];
		displayIcon: [ :aClass | self iconForClass: aClass ].
	
	packagesTreePresenter 
		transmitTo: classesTreePresenter
		transform: [ :aPackageOrTag | self classesOf: aPackageOrTag ]
]

{ #category : #private }
StBrowserPackagesPresenter >> nameForClass: aClass [
		
	^ aClass name
]

{ #category : #private }
StBrowserPackagesPresenter >> nameForPackage: aPackage [
		
	^ aPackage browserName
]

{ #category : #initialization }
StBrowserPackagesPresenter >> updatePresenter [

	packagesTreePresenter roots: self model packages
]
