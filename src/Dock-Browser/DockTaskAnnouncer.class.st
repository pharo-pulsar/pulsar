Class {
	#name : 'DockTaskAnnouncer',
	#superclass : 'Announcer',
	#instVars : [
		'runner'
	],
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

	runner schedule: [ super announce: anAnnouncement ]
]

{ #category : 'initialization' }
DockTaskAnnouncer >> initialize [

	super initialize.
	runner := TKTWorker new start
		
]

{ #category : 'testing' }
DockTaskAnnouncer >> isSynchronic: anAnnouncement [ 

	^ self class synchronicAnnouncements includes: anAnnouncement class
]
