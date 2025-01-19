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

	^ { SpWindowWillClose }
]

{ #category : 'announce' }
DockTaskAnnouncer >> announce: anAnnouncement [
	(self isSynchronic: anAnnouncement)
		ifTrue: [ ^ super announce: anAnnouncement ].

	self schedule: [ super announce: anAnnouncement ]
]

{ #category : 'testing' }
DockTaskAnnouncer >> isSynchronic: anAnnouncement [ 

	^ self class synchronicAnnouncements includes: anAnnouncement class
]
