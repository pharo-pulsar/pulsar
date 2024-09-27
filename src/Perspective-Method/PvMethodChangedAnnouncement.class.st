Class {
	#name : 'PvMethodChangedAnnouncement',
	#superclass : 'PvChangedAnnouncement',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvMethodChangedAnnouncement >> performSelector [

	^ #methodChanged:
]
