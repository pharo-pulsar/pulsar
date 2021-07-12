Class {
	#name : #StEnvironmentBrowser,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'projectsPresenter',
		'packagesPresenter',
		'classesPresenter'
	],
	#category : #'NewTools-Browser'
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

{ #category : #initialization }
StEnvironmentBrowser >> initializeEnvironment: anEnvironment [

	model := StEnvironmentBrowserModel on: anEnvironment.
	self initialize
]

{ #category : #initialization }
StEnvironmentBrowser >> initializePresenters [

	self layout: (SpPanedLayout newTopToBottom
		add: (SpPanedLayout newLeftToRight
			add: (SpTabLayout new 
				add: (projectsPresenter := self newBaselinesPanel) label: 'Baselines';
				add: (packagesPresenter := self newPackagesPanel) label: 'Packages';
				add: (classesPresenter := self newClassesPanel) label: 'Classes';
				yourself);
			add: (SpTabLayout new);
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

{ #category : #initialization }
StEnvironmentBrowser >> newBaselinesPanel [
		
	^ self 
		instantiate: StBrowserBaselinesPresenter 
		on: self model
]

{ #category : #initialization }
StEnvironmentBrowser >> newClassesPanel [
		
	^ self newList
]

{ #category : #initialization }
StEnvironmentBrowser >> newPackagesPanel [
		
	^ self 
		instantiate: StBrowserPackagesPresenter 
		on: self model
]
