Class {
	#name : 'PulsarRequestToolAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'model'
	],
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'instance creation' }
PulsarRequestToolAnnouncement class >> on: anObject [

	^ self new 
		model: anObject;
		yourself
]

{ #category : 'testing' }
PulsarRequestToolAnnouncement >> isUnique [
	"override is there can not be multiple versions of requested tool"

	^ false
]

{ #category : 'accessing' }
PulsarRequestToolAnnouncement >> model [

	^ model
]

{ #category : 'accessing' }
PulsarRequestToolAnnouncement >> model: anObject [

	model := anObject
]

{ #category : 'accessing' }
PulsarRequestToolAnnouncement >> toolClass [

	self subclassResponsibility
]
