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

	^ SpPanedLayout newVertical
		add: commentPresenter;
		add: super defaultLayout;
		yourself
]

{ #category : 'events' }
DockClassEditor >> eventModelRemoved: anAnnouncememnt [ 

	self flag: #TODO
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
DockClassEditor >> updateBreadcrumbs [

	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: self model name ]
]

{ #category : 'initialization' }
DockClassEditor >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	super updatePresenter.
	
	self updatingWhile: [  
		editorPresenter text: self model classDefinitionString ].
	
	self flag: #REVIEW. "select template tab by defdault (as comment should be introduced later)?"
	self flag: #TODO. "I need a better way than to wait until it is built. I maybe need to implement #withAdapterPerformOrDefer: in the tab layout"
	"self model isNew ifTrue: [ 
		self whenBuiltDo: [ 
			self layout selectIndex: 2 ] ]"
]
