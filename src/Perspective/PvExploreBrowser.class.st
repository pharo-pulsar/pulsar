Class {
	#name : 'PvExploreBrowser',
	#superclass : 'PvPerspectiveBrowser',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'projectView',
		'outlineView'
	],
	#category : 'Perspective-View-Perspective',
	#package : 'Perspective',
	#tag : 'View-Perspective'
}

{ #category : 'activating' }
PvExploreBrowser >> activateClass: aClass [

	self editorContainer entityActivated: (PvClassModel 
		newEnvironment: self model environmentModel 
		entity: aClass)
]

{ #category : 'activating' }
PvExploreBrowser >> activateMethod: aMethod [

	self editorContainer entityActivated: (PvMethodModel 
		newEnvironment: self model environmentModel 
		entity: aMethod)
]

{ #category : 'initialization' }
PvExploreBrowser >> connectViews [

	self flag: #TODO. "Refactor"
	projectView outputSelectionPort transmitTo: outlineView inputSelectedPort.
	projectView outputActivationPort 
		transmitTo: self editorContainer inputActivatedPort;
		transmitTo: outlineView inputActivatedPort.
	outlineView outputActivationPort 
		transmitTo: self editorContainer inputActivatedPort.
	self editorContainer outputSelectionPort 
		transmitTo: outlineView inputSelectedPort;
		transmitTo: projectView inputSelectedPort
]

{ #category : 'initialization' }
PvExploreBrowser >> initializeViews [

	projectView := self addWindowOfClass: PvProjectView atContainerNamed: #overview.
	outlineView := self addWindowOfClass: PvOutlineView atContainerNamed: #overview
]

{ #category : 'actions' }
PvExploreBrowser >> openProject: aBaselineClass [

	projectView model: (PvProjectModel 
		newEntity: aBaselineClass
		environment: self model)
]

{ #category : 'initialization' }
PvExploreBrowser >> perspectiveLayoutClass [

	^ PvExplorePerspectiveLayout
]
