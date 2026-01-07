Class {
	#name : 'PulsarLostChangesAnnouncement',
	#superclass : 'PulsarAnnouncement',
	#instVars : [
		'detector'
	],
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'accessing' }
PulsarLostChangesAnnouncement >> detector [

	^ detector
]

{ #category : 'accessing' }
PulsarLostChangesAnnouncement >> detector: aLostChangesDetector [

	detector := aLostChangesDetector
]
