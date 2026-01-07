Class {
	#name : 'PulsarAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'value'
	],
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'instance creation' }
PulsarAnnouncement class >> newValue: anObject [

	^ self new value: anObject
]

{ #category : 'accessing' }
PulsarAnnouncement >> value [

	^ value
]

{ #category : 'accessing' }
PulsarAnnouncement >> value: anObject [

	value := anObject
]
