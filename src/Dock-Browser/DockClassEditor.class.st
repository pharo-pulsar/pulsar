Class {
	#name : 'DockClassEditor',
	#superclass : 'DockEditor',
	#category : 'Dock-Browser-Core',
	#package : 'Dock-Browser',
	#tag : 'Core'
}

{ #category : 'accessing - actions' }
DockClassEditor class >> defineActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #navigation with: { 
		$h mod1 -> PvClassHierarchyNavigationCommand new
	}
]

{ #category : 'initialization' }
DockClassEditor >> initializePresenters [

	super initializePresenters.
	self addStyle: 'dockClassEditor'
]

{ #category : 'initialization' }
DockClassEditor >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self updatingWhile: [  
		editorPresenter text: self model classDefinitionString ].
	
	"update window title if needed"
	self withDockableWindowDo: [ :w | w title: self model name ]
]
