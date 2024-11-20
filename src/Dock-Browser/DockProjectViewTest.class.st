Class {
	#name : 'DockProjectViewTest',
	#superclass : 'DockBaseViewTest',
	#instVars : [
		'presenter'
	],
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser',
	#tag : 'Tests'
}

{ #category : 'accessing' }
DockProjectViewTest >> classToTest [

	^ DockProjectView
]

{ #category : 'running' }
DockProjectViewTest >> setUp [
	super setUp.

	presenter := self application new: self classToTest
]

{ #category : 'tests' }
DockProjectViewTest >> testActions [

	self assert: presenter actions notNil.
	self 
		assertCollection: (presenter actions allCommands collect: [ :each | each decoratedCommand class ])
		hasSameElements: {
			PvNewProjectCommand. 
			PvOpenProjectCommand. 
			PvRefreshProjectCommand. 
			PvNewPackageCommand. 
			PvNewPackageTagCommand. 
			PvNewClassCommand. 
			PvNewTraitCommand. 
			PvRenamePackageCommand. 
			PvRemovePackageCommand }
]
