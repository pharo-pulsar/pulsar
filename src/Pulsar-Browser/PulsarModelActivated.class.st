Class {
	#name : 'PulsarModelActivated',
	#superclass : 'PulsarAnnouncement',
	#instVars : [
		'selection',
		'desiredPosition'
	],
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'accessing' }
PulsarModelActivated >> desiredPosition [

	^ desiredPosition
]

{ #category : 'accessing' }
PulsarModelActivated >> desiredPosition: aPanelPosition [

	desiredPosition := aPanelPosition
]

{ #category : 'testing' }
PulsarModelActivated >> hasDesiredPosition [

	^ self desiredPosition isNotNil
]

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
