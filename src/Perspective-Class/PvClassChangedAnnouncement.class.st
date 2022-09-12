Class {
	#name : #PvClassChangedAnnouncement,
	#superclass : #PvChangedAnnouncement,
	#category : #'Perspective-Class-Model'
}

{ #category : #accessing }
PvClassChangedAnnouncement >> performSelector [

	^ #classChanged:
]
