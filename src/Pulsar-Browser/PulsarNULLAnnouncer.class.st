"
A special announcement to eat the announcements. 
This will be used in the cases were we need an announcement on not yet installed editors/panels (this may happen specialy when restoring sessions). 
This will be used notably on `PulsarTNotificationCenter`, but other usages may be need.
"
Class {
	#name : 'PulsarNULLAnnouncer',
	#superclass : 'Announcer',
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'announce' }
PulsarNULLAnnouncer >> announce: ann [

	logger trace: ann
]
