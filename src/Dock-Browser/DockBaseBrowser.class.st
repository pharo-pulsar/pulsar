Class {
	#name : 'DockBaseBrowser',
	#superclass : 'DockDockWindowPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#category : 'Dock-Browser-Base',
	#package : 'Dock-Browser',
	#tag : 'Base'
}

{ #category : 'private' }
DockBaseBrowser >> addWindow: aWindow [

	aWindow presenter registerToDock: self.
	super addWindow: aWindow.
	aWindow raise
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

	"broadcast"
	self announcer when: DockAnnouncement send: #resendAnnouncement: to: self.
	"now process here"
	self announcer 
		when: DockModelActivated 
		send: #eventModelActivated:
		to: self.
	"self announcer 
		when: DockModelSelectedAnnouncement 
		send: #eventModelSelected:
		to: self"
]

{ #category : 'announcing' }
DockBaseBrowser >> resendAnnouncement: anAnnouncement [

	self presentersDo: [ :aWindowPresenter |
		aWindowPresenter presenter announce: anAnnouncement ]
]
