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

{ #category : 'announcing' }
PulsarTaskAnnouncer >> announce: anAnnouncement [

	logger trace: anAnnouncement.

	"not the best if you want to record the announcements (see super 
	 implementation), but well..."
	(self isSuspended or: [ self isSynchronic: anAnnouncement ]) 
		ifTrue: [ ^ super announce: anAnnouncement ].

	self queueTask: [ 
		[ super announce: anAnnouncement ]
		on: Error 
		fork: [ :e | e pass ] ]
]

{ #category : 'announcing' }
PulsarTaskAnnouncer >> announceError: anError [

	self announce: (PulsarErrorAnnouncement newValue: anError)
]

{ #category : 'announcing' }
PulsarTaskAnnouncer >> announceInform: aString [

	self announce: (PulsarInformAnnouncement newValue: aString)
]

{ #category : 'announcing' }
PulsarTaskAnnouncer >> announceWarning: aWarning [

	self announce: (PulsarWarningAnnouncement newValue: aWarning)
]

{ #category : 'testing' }
PulsarTaskAnnouncer >> isSynchronic: anAnnouncement [ 

	^ self class synchronicAnnouncements includes: anAnnouncement class
]
