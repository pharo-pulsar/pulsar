Class {
	#name : #PvExploreBrowser,
	#superclass : #PvPerspectiveBrowser,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'projectView',
		'outlineView'
	],
	#category : #'Perspective-View-Perspective'
}

{ #category : #initialization }
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

{ #category : #initialization }
PvExploreBrowser >> initializeViews [

	self addWindow: (projectView := PvProjectView new) atContainerNamed: #overview.
	self addWindow: (outlineView := PvOutlineView new) atContainerNamed: #overview
]

{ #category : #actions }
PvExploreBrowser >> openProject: aBaselineClass [

	projectView model: (PvProjectModel 
		newEntity: aBaselineClass
		environment: self model)
]

{ #category : #initialization }
PvExploreBrowser >> perspectiveLayoutClass [

	^ PvExplorePerspectiveLayout
]
