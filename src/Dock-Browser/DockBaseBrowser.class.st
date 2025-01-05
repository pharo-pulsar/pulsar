Class {
	#name : 'DockBaseBrowser',
	#superclass : 'DockDockWindowPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

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

{ #category : 'initialization' }
DockBaseBrowser >> initialize [

	super initialize.
	self registerToEvents
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
