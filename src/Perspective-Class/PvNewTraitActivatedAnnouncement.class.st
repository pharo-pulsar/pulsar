Class {
	#name : #PvNewTraitActivatedAnnouncement,
	#superclass : #PvClassActivatedAnnouncement,
	#category : #'Perspective-Class-Model'
}

{ #category : #accessing }
PvNewTraitActivatedAnnouncement >> performSelector [

	^ #newClassActivated:
]
