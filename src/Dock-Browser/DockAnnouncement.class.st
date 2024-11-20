Class {
	#name : 'DockAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'value'
	],
	#category : 'Dock-Browser-Core',
	#package : 'Dock-Browser',
	#tag : 'Core'
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
