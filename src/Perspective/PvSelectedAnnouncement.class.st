Class {
	#name : #PvSelectedAnnouncement,
	#superclass : #PvAnnouncement,
	#category : #'Perspective-Announcement'
}

{ #category : #accessing }
PvSelectedAnnouncement >> performSelector [

	^ #entitySelected:
]
