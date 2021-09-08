Class {
	#name : #StEnvironmentBrowser,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'projectsPresenter',
		'packagesPresenter',
		'hierarchyPresenter',
		'classPanel'
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
		
	^ classPanel ifNil: [ classPanel := self newClassPanel ]
]

{ #category : #'private - accessing' }
StEnvironmentBrowser >> hierarchyPanel [
		
	^ hierarchyPresenter ifNil: [ hierarchyPresenter := self newHierarchyPanel ]
]

{ #category : #initialization }
StEnvironmentBrowser >> initializeEnvironment: anEnvironment [

	model := StEnvironmentBrowserModel on: anEnvironment.
	self initialize
]

{ #category : #initialization }
StEnvironmentBrowser >> initializePresenters [

	self layout: (SpPanedLayout newTopToBottom
		add: (SpPanedLayout newLeftToRight
			add: (self newNotebook
				"add: (projectsPresenter := self newBaselinesPanel) label: 'Baselines';"
				addPageTitle: 'Packages' provider: [ self packagesPanel ];
				addPageTitle: 'Hierarchy' provider: [ self hierarchyPanel ];
				yourself);
			add: self classPanel;
			yourself);
		add: (SpTabLayout new);
		yourself)
]

{ #category : #initialization }
StEnvironmentBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Browser';
		initialExtent: self class preferredExtent
]

{ #category : #'private - factory' }
StEnvironmentBrowser >> newBaselinesPanel [
		
	^ self 
		instantiate: StBrowserBaselinesPresenter 
		on: self model
]

{ #category : #'private - factory' }
StEnvironmentBrowser >> newClassPanel [
		
	^ self instantiate: StBrowserClassPresenter
]

{ #category : #'private - factory' }
StEnvironmentBrowser >> newHierarchyPanel [
		
	^ self newList
]

{ #category : #'private - factory' }
StEnvironmentBrowser >> newPackagesPanel [
		
	^ self instantiate: StBrowserPackageListPresenter on: self model
]

{ #category : #initialization }
StEnvironmentBrowser >> packagesPanel [

	^ packagesPresenter ifNil: [ 
		packagesPresenter := self newPackagesPanel.
		packagesPresenter transmitTo: self classPanel.
		packagesPresenter ]
]
