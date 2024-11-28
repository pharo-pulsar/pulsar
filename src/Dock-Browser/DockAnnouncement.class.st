Class {
	#name : 'DockAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'value'
	],
	#category : 'Dock-Browser-Announcement',
	#package : 'Dock-Browser',
	#tag : 'Announcement'
}

{ #category : 'instance creation' }
DockAnnouncement class >> newValue: anObject [

	^ self new value: anObject
]

{ #category : 'accessing' }
DockAnnouncement >> value [

	^ value
]

{ #category : 'accessing' }
DockAnnouncement >> value: anObject [

	value := anObject
]
