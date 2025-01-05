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

{ #category : 'announce' }
DockTaskAnnouncer >> announce: anAnnouncement [

	runner schedule: [ super announce: anAnnouncement ]
]

{ #category : 'initialization' }
DockTaskAnnouncer >> initialize [

	super initialize.
	runner := TKTWorker new start
		
]
