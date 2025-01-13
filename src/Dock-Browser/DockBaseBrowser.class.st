Class {
	#name : 'DockBaseBrowser',
	#superclass : 'DockDockWindowPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'actions'
	],
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'private' }
DockBaseBrowser >> addGlobalActionsTo: aWindowPresenter [

	self globalActions 
		ifNotNil: [ :aGroup | aWindowPresenter actions: aGroup ]
]

{ #category : 'private' }
DockBaseBrowser >> addWindow: aWindow [

	aWindow presenter registerToDock: self.
	super addWindow: aWindow.
	aWindow raise
]

{ #category : 'accessing' }
DockBaseBrowser >> announcer [

	^ announcer ifNil: [ announcer := DockTaskAnnouncer new ]
]

{ #category : 'events' }
DockBaseBrowser >> eventModelActivated: anAnnouncement [
	
]

{ #category : 'private - settings' }
DockBaseBrowser >> globalActions [

	^ PvActionCollector collectFor: self
]

{ #category : 'initialization' }
DockBaseBrowser >> initialize [

	super initialize.
	self registerToEvents
]

{ #category : 'initialization' }
DockBaseBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	self addGlobalActionsTo: self
]

{ #category : 'initialization' }
DockBaseBrowser >> registerToEvents [

	self announcer 
		"first broadcast"
		when: DockAnnouncement send: #resendAnnouncement: to: self;
		"now process here"
		when: DockModelActivated send: #eventModelActivated: to: self
]

{ #category : 'announcing' }
DockBaseBrowser >> resendAnnouncement: anAnnouncement [

	self presentersDo: [ :aWindowPresenter |
		aWindowPresenter presenter announce: anAnnouncement ]
]

{ #category : 'accessing' }
DockBaseBrowser >> systemNavigation [

	^ DockSystemNavigation newWindow: self
]
