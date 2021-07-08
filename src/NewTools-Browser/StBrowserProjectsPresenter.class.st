Class {
	#name : #StBrowserProjectsPresenter,
	#superclass : #StBrowserPanelPresenter,
	#instVars : [
		'projectsTreePresenter',
		'classesTreePresenter'
	],
	#category : #'NewTools-Browser'
}

{ #category : #initialization }
StBrowserProjectsPresenter >> childrenOf: aProjectOrPackage [
	
	aProjectOrPackage ifNil: [ ^ #() ].
	(aProjectOrPackage isClass 
		and: [ (self isBaseline: aProjectOrPackage) not ]) 
		ifTrue: [ ^ #() ].
	^ aProjectOrPackage browserChildren
]

{ #category : #initialization }
StBrowserProjectsPresenter >> classesOf: aProjectOrPackage [
	
	aProjectOrPackage ifNil: [ ^ #() ].
	^ aProjectOrPackage browserClasses
]

{ #category : #initialization }
StBrowserProjectsPresenter >> initializePresenters [

	self layout: (SpPanedLayout newLeftToRight
		add: (projectsTreePresenter := self newTree);
		add: (classesTreePresenter := self newTree);
		yourself).
		
	projectsTreePresenter 
		display: [ :aProjectOrPackage | aProjectOrPackage browserName ];
		children: [ :aProjectOrPackage | self childrenOf: aProjectOrPackage ].
	classesTreePresenter display: [ :aClass | aClass name ].
	
	projectsTreePresenter 
		transmitTo: classesTreePresenter
		transform: [ :aBaselineClass | self classesOf: aBaselineClass ]
]

{ #category : #initialization }
StBrowserProjectsPresenter >> isBaseline: aProjectOrPackage [

	^ aProjectOrPackage inheritsFrom: BaselineOf
]

{ #category : #initialization }
StBrowserProjectsPresenter >> updatePresenter [

	projectsTreePresenter roots: self model projects
]
