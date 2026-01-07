Class {
	#name : 'PulsarEditorActivated',
	#superclass : 'PulsarAnnouncement',
	#instVars : [
		'detector'
	],
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'accessing' }
PulsarEditorActivated >> detector [

	^ detector
]

{ #category : 'accessing' }
PulsarEditorActivated >> detector: aLostChangesDetector [

	detector := aLostChangesDetector
]
