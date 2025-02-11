Class {
	#name : 'DockMethodEditor',
	#superclass : 'DockEditor',
	#instVars : [
		'protocolPresenter'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing - actions' }
DockMethodEditor class >> defineActionGroupNavigation: actionGroup [
	<perspectiveActionGroup: #navigation>
	
	actionGroup 
		priority: 100;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockMethodEditor class >> defineActionGroupStructuring: actionGroup [
	<perspectiveActionGroup: #structuring>
	
	actionGroup
		priority: -10;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockMethodEditor class >> defineActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder 
		registerGroup: #structuring with: {  
			$p mod1 shift -> DockCategoriseMethodCommand new
		};
		registerGroup: #navigation with: { 
			$h mod1 -> DockHierarchyNavigationCommand new
		}
]

{ #category : 'private' }
DockMethodEditor >> announceActivateClass [
	
	self notifyActivateEntity: self model asClassModel
]

{ #category : 'initialization' }
DockMethodEditor >> connectPresenters [

	super connectPresenters.
	protocolPresenter whenProtocolChangedDo: [ :aProtocolModel |
		self notifyEntityChanged: self model ]
]

{ #category : 'private - actions' }
DockMethodEditor >> doRequestChangeProtocol [

	protocolPresenter popupProtocol
]

{ #category : 'events' }
DockMethodEditor >> eventModelChanged: ann [
	
	ann value = self model ifFalse: [ ^ self ].
	
	super eventModelChanged: ann.
	self updateProtocol
]

{ #category : 'events' }
DockMethodEditor >> eventModelRemoved: anAnnouncememnt [ 

	anAnnouncememnt value = self model ifFalse: [ ^ self ].

	self withPanelWindowDo: [ :aWindow | aWindow close ]
]

{ #category : 'initialization' }
DockMethodEditor >> initializePresenters [

	super initializePresenters.
	
	protocolPresenter := self instantiate: DockProtocolButtonPresenter.
	toolbarPresenter addPresenter: protocolPresenter.
	
	self addStyle: 'dockMethodEditor'
]

{ #category : 'private' }
DockMethodEditor >> originalContent [

	^ self model sourceCode
]

{ #category : 'initialization' }
DockMethodEditor >> updateBreadcrumbs [

	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb |
		aBreadcrumb 
			addLinkSegment: self model methodClassName action: [ self announceActivateClass ];
			addSegment: self model name ]
]

{ #category : 'initialization' }
DockMethodEditor >> updatePresenter [

	self model ifNil: [ ^ self ].

	super updatePresenter.
		
	self updatingWhile: [  
		self updateProtocol.
		editorPresenter 
			beForMethod: self model entity;
			text: self model sourceCode ]
]

{ #category : 'initialization' }
DockMethodEditor >> updateProtocol [

	protocolPresenter model: self model
]
