Class {
	#name : #PvChangedAnnouncement,
	#superclass : #PvAnnouncement,
	#category : #'Perspective-Announcement'
}

{ #category : #accessing }
PvChangedAnnouncement >> performSelector [

	^ #entityChanged:
]
