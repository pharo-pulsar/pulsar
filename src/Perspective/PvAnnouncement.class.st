Class {
	#name : 'PvAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'model'
	],
	#category : 'Perspective-Announcement',
	#package : 'Perspective',
	#tag : 'Announcement'
}

{ #category : 'instance creation' }
PvAnnouncement class >> for: aModel [

	^ self new model: aModel
]

{ #category : 'visiting' }
PvAnnouncement >> handleOn: aView [

	"A bit of reflection to bypass views not implementing the visitor (Because they do not want it)"
	(aView respondsTo: self performSelector) ifFalse: [ ^ self ].
	
	^ aView 
		perform: self performSelector 
		with: self model
]

{ #category : 'accessing' }
PvAnnouncement >> model [

	^ model
]

{ #category : 'accessing' }
PvAnnouncement >> model: anObject [

	model := anObject
]

{ #category : 'accessing' }
PvAnnouncement >> performSelector [

	^ self subclassResponsibility
]
