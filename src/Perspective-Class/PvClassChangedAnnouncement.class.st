Class {
	#name : 'PvClassChangedAnnouncement',
	#superclass : 'PvChangedAnnouncement',
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvClassChangedAnnouncement >> performSelector [

	^ #classChanged:
]
