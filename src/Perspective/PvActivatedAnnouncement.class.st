Class {
	#name : #PvActivatedAnnouncement,
	#superclass : #PvAnnouncement,
	#category : #'Perspective-Announcement'
}

{ #category : #accessing }
PvActivatedAnnouncement >> performSelector [

	^ #entityActivated:
]
