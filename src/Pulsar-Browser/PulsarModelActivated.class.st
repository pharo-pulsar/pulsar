Class {
	#name : 'PulsarModelActivated',
	#superclass : 'PulsarAnnouncement',
	#instVars : [
		'selection'
	],
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'testing' }
PulsarModelActivated >> hasSelection [

	^ self selection isNotNil
]

{ #category : 'accessing' }
PulsarModelActivated >> selection [

	^ selection
]

{ #category : 'accessing' }
PulsarModelActivated >> selection: anInterval [

	selection := anInterval
]
