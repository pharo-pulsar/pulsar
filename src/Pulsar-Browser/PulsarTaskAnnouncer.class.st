Class {
	#name : 'PulsarTaskAnnouncer',
	#superclass : 'Announcer',
	#traits : 'PulsarTTaskWorker',
	#classTraits : 'PulsarTTaskWorker classTrait',
	#category : 'Pulsar-Browser-View-Browser',
	#package : 'Pulsar-Browser',
	#tag : 'View-Browser'
}

{ #category : 'private' }
PulsarTaskAnnouncer class >> synchronicAnnouncements [

	^ { SpWindowWillClose. PulsarModelDeactivated }
]

{ #category : 'announce' }
PulsarTaskAnnouncer >> announce: anAnnouncement [

	"not the best if you want to record the announcements (see super 
	 implementation), but well..."
	(self isSuspended or: [ self isSynchronic: anAnnouncement ]) 
		ifTrue: [ ^ super announce: anAnnouncement ].

	self queueTask: [ 
		[ super announce: anAnnouncement ]
		on: Error 
		fork: [ :e | e pass ] ]
]

{ #category : 'testing' }
PulsarTaskAnnouncer >> isSynchronic: anAnnouncement [ 

	^ self class synchronicAnnouncements includes: anAnnouncement class
]
