Class {
	#name : 'PvChangedAnnouncement',
	#superclass : 'PvAnnouncement',
	#category : 'Perspective-Announcement',
	#package : 'Perspective',
	#tag : 'Announcement'
}

{ #category : 'accessing' }
PvChangedAnnouncement >> performSelector [

	^ #entityChanged:
]
