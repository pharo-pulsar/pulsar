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

{ #category : 'actions' }
DockMethodEditor >> doBrowseVersionsCommand: anAction [
	| popover versionsPresenter |

	popover := self newPopover.

	versionsPresenter := self
		instantiate: DockVersionsBrowser 
		on: self model newVersionsModel.
	versionsPresenter registerToDock: self window.

	popover := self newPopover
		presenter: versionsPresenter;
		relativeTo: anAction presenter;
		bePositionBottom;
		popupModal
]

{ #category : 'private - actions' }
DockMethodEditor >> doRequestChangeProtocol [

	protocolPresenter popupProtocol
]

{ #category : 'private - actions' }
DockMethodEditor >> doRunSampleInstanceCommand: anAction [
	| result |

	result := self model runScript.
	self flag: #TODO. "Open an inspector with the result"
]

{ #category : 'private - actions' }
DockMethodEditor >> doRunScriptCommand: anAction [

	self model runScript
]

{ #category : 'private - actions' }
DockMethodEditor >> doSubmit: aString [

	super doSubmit: aString.
	self updateContentActions
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
DockMethodEditor >> updateEditor [

	editorPresenter 
		beForMethod: self model entity;
		text: self model sourceCode
]

{ #category : 'initialization' }
DockMethodEditor >> updatePresenter [

	self model ifNil: [ ^ self ].

	super updatePresenter.
		
	self updatingWhile: [  
		self updateProtocol.
		self updateEditor ]
]

{ #category : 'initialization' }
DockMethodEditor >> updateProtocol [

	protocolPresenter model: self model
]
