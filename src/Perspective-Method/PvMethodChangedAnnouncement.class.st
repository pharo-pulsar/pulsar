Class {
	#name : #PvMethodChangedAnnouncement,
	#superclass : #PvChangedAnnouncement,
	#category : #'Perspective-Method-Model'
}

{ #category : #accessing }
PvMethodChangedAnnouncement >> performSelector [

	^ #methodChanged:
]
