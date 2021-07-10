Class {
	#name : #StBrowserBaselinesPresenter,
	#superclass : #StBrowserPanelPresenter,
	#instVars : [
		'projectsTreePresenter',
		'classesTreePresenter'
	],
	#category : #'NewTools-Browser'
}

{ #category : #initialization }
StBrowserBaselinesPresenter >> childrenOf: aProjectOrPackage [
	
	aProjectOrPackage ifNil: [ ^ #() ].
	^ aProjectOrPackage browserPackageChildren
]

{ #category : #initialization }
StBrowserBaselinesPresenter >> classesOf: aProjectOrPackage [
	
	aProjectOrPackage ifNil: [ ^ #() ].
	^ aProjectOrPackage browserClasses
]

{ #category : #initialization }
StBrowserBaselinesPresenter >> initializePresenters [

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
StBrowserBaselinesPresenter >> isBaseline: aProjectOrPackage [

	^ aProjectOrPackage inheritsFrom: BaselineOf
]

{ #category : #initialization }
StBrowserBaselinesPresenter >> updatePresenter [

	projectsTreePresenter roots: self model projects
]
