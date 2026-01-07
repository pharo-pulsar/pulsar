Class {
	#name : 'PulsarModelChanged',
	#superclass : 'PulsarAnnouncement',
	#instVars : [
		'oldEntity'
	],
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'instance creation' }
PulsarModelChanged class >> newValue: anObject oldEntity: anEntity [

	^ (self newValue: anObject)
		oldEntity: anEntity;
		yourself
]

{ #category : 'accessing' }
PulsarModelChanged >> oldEntity [

	^ oldEntity
]

{ #category : 'accessing' }
PulsarModelChanged >> oldEntity: anObject [

	oldEntity := anObject
]
