Class {
	#name : #PvNewClassActivatedAnnouncement,
	#superclass : #PvClassActivatedAnnouncement,
	#category : #'Perspective-Class-Model'
}

{ #category : #accessing }
PvNewClassActivatedAnnouncement >> performSelector [

	^ #newClassActivated:
]
