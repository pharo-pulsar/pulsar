Class {
	#name : 'DockTaskAnnouncer',
	#superclass : 'Announcer',
	#traits : 'DockTScheduling',
	#classTraits : 'DockTScheduling classTrait',
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'private' }
DockTaskAnnouncer class >> synchronicAnnouncements [

	^ { SpWindowWillClose. DockModelDeactivated }
]

{ #category : 'announce' }
DockTaskAnnouncer >> announce: anAnnouncement [
	"not the best if you want to record the announcements (see super 
	 implementation), but well..."
	(self isSuspended or: [ self isSynchronic: anAnnouncement ])
		ifTrue: [ ^ super announce: anAnnouncement ].

	self schedule: [ 
		super announce: anAnnouncement ]
]

{ #category : 'testing' }
DockTaskAnnouncer >> isSynchronic: anAnnouncement [ 

	^ self class synchronicAnnouncements includes: anAnnouncement class
]
