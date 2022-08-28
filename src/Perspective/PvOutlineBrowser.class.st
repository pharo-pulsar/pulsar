Class {
	#name : #PvOutlineBrowser,
	#superclass : #PvExploreBrowser,
	#category : #'Perspective-View-Perspective'
}

{ #category : #initialization }
PvOutlineBrowser >> connectViews [

	"plug all tools -> this has to be refactored"
	projectView outputActivationPort 
		transmitTo: outlineView inputActivatedPort;
		transmitTo: self editorContainer inputActivatedPort.
	outlineView outputActivationPort 
		transmitTo: self editorContainer inputActivatedPort.
	self editorContainer outputSelectionPort 
		transmitTo: outlineView inputSelectedPort;
		transmitTo: projectView inputSelectedPort
]

{ #category : #initialization }
PvOutlineBrowser >> initializeViews [

	self addWindow: (projectView := PvProjectView new) atContainerNamed: #overview.
	self addWindow: (outlineView := PvOutlineView new) atContainerNamed: #outline.
	self addWindow: (StPlayground newApplication: self application) atContainerNamed: #tools
]

{ #category : #initialization }
PvOutlineBrowser >> perspectiveLayoutClass [

	^ PvOutlinePerspectiveLayout
]
