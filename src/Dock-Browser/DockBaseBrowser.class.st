Class {
	#name : 'DockBaseBrowser',
	#superclass : 'SpPanelWindowPresenter',
	#traits : 'SpTModel + DockTSnapshot',
	#classTraits : 'SpTModel classTrait + DockTSnapshot classTrait',
	#instVars : [
		'actions',
		'mutex'
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

	self mutex critical: [ 
		aWindow presenter registerToDock: self.
		super addWindow: aWindow.
		aWindow raise ]
]

{ #category : 'accessing' }
DockBaseBrowser >> editors [

	^ self mutex critical: [ 
		super presenters select: [ :each | each dockArea = SpPanelArea center ] ]
]

{ #category : 'events' }
DockBaseBrowser >> eventModelActivated: anAnnouncement [
	
]

{ #category : 'private - settings' }
DockBaseBrowser >> globalActions [

	^ PvActionCollector collectFor: self
]

{ #category : 'simple dialog helpers' }
DockBaseBrowser >> inform: aString [

	('INFORM: ', aString) crTrace
]

{ #category : 'initialization' }
DockBaseBrowser >> initialize [

	super initialize.
	self registerToEvents
]

{ #category : 'private - initialization' }
DockBaseBrowser >> initializePrivateAnnouncer [

  announcer := DockTaskAnnouncer new
]

{ #category : 'initialization' }
DockBaseBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	self addGlobalActionsTo: self
]

{ #category : 'private' }
DockBaseBrowser >> mutex [

	^  mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'private' }
DockBaseBrowser >> notificationCenter [
	"using my own announcer as notification center"
	^ self announcer
]

{ #category : 'accessing' }
DockBaseBrowser >> presenters [
 
	^  self mutex critical: [ super presenters ]
]

{ #category : 'initialization' }
DockBaseBrowser >> registerToEvents [

	self announcer 
		"first broadcast"
		when: DockAnnouncement send: #resendAnnouncement: to: self;
		"now process here"
		when: DockModelActivated send: #eventModelActivated: to: self;
		when: DockModelDeactivated send: #eventModelDeactivated: to: self
]

{ #category : 'announcing' }
DockBaseBrowser >> resendAnnouncement: anAnnouncement [
	
	self presentersDo: [ :aWindowPresenter |
		aWindowPresenter presenter announce: anAnnouncement ]
]

{ #category : 'private - schedulling' }
DockBaseBrowser >> schedule: aBlock [

	^ self scheduler schedule: aBlock
]

{ #category : 'private - schedulling' }
DockBaseBrowser >> scheduler [

	^ self application scheduler
]

{ #category : 'accessing - snapshot' }
DockBaseBrowser >> snapshot [

	^ DockBrowserSnapshot on: self
]

{ #category : 'accessing' }
DockBaseBrowser >> systemNavigation [

	^ DockSystemNavigation newWindow: self
]

{ #category : 'private' }
DockBaseBrowser >> windowClosed [

	super windowClosed.
	announcer stopScheduler
]
