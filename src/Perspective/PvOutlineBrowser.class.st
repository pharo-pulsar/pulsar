Class {
	#name : 'PvOutlineBrowser',
	#superclass : 'PvExploreBrowser',
	#category : 'Perspective-View-Perspective',
	#package : 'Perspective',
	#tag : 'View-Perspective'
}

{ #category : 'initialization' }
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

{ #category : 'initialization' }
PvOutlineBrowser >> initializeViews [

	projectView := self addWindowOfClass: PvProjectView atContainerNamed: #overview.
	outlineView := self addWindowOfClass: PvOutlineView atContainerNamed: #outline.
	self addWindowOfClass: StPlayground atContainerNamed: #tools
]

{ #category : 'initialization' }
PvOutlineBrowser >> perspectiveLayoutClass [

	^ PvOutlinePerspectiveLayout
]
