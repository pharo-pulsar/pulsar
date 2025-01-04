Class {
	#name : 'DockClassEditor',
	#superclass : 'DockEditor',
	#instVars : [
		'commentPresenter'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing - actions' }
DockClassEditor class >> defineActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #navigation with: { 
		$h mod1 -> PvClassHierarchyNavigationCommand new
	}
]

{ #category : 'layout' }
DockClassEditor >> defaultLayout [ 

	^ SpTabLayout new
		add: commentPresenter label: 'Comment';
		add: super defaultLayout label: 'Template';
		yourself
]

{ #category : 'initialization' }
DockClassEditor >> initializePresenters [

	super initializePresenters.
	self addStyle: 'dockClassEditor'.

	commentPresenter := self newLabel
]

{ #category : 'private' }
DockClassEditor >> originalContent [

	^ self model classDefinitionString
]

{ #category : 'initialization' }
DockClassEditor >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self updatingWhile: [  
		editorPresenter text: self model classDefinitionString ].
	
	"update window title if needed"
	self withPanelWindowDo: [ :w | w title: self model name ].
	
	self flag: #REVIEW. "select template tab by defdault (as comment should be introduced later)?"
	self flag: #TODO. "I need a better way than to wait until it is built. I maybe need to implement #withAdapterPerformOrDefer: in the tab layout"
	self model isNew ifTrue: [ 
		self whenBuiltDo: [ 
			self layout selectIndex: 2 ] ]
]
