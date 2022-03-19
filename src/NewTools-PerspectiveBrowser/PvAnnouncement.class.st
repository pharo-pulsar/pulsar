Class {
	#name : #PvAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'model'
	],
	#category : #'NewTools-PerspectiveBrowser-Announcements'
}

{ #category : #'instance creation' }
PvAnnouncement class >> for: aModel [

	^ self new model: aModel
]

{ #category : #accessing }
PvAnnouncement >> model [

	^ model
]

{ #category : #accessing }
PvAnnouncement >> model: anObject [

	model := anObject
]
