Class {
	#name : 'DockModelChanged',
	#superclass : 'DockAnnouncement',
	#instVars : [
		'oldEntity'
	],
	#category : 'Dock-Browser-Announcement',
	#package : 'Dock-Browser',
	#tag : 'Announcement'
}

{ #category : 'instance creation' }
DockModelChanged class >> newValue: anObject oldEntity: anEntity [

	^ (self newValue: anObject)
		oldEntity: anEntity;
		yourself
]

{ #category : 'accessing' }
DockModelChanged >> oldEntity [

	^ oldEntity
]

{ #category : 'accessing' }
DockModelChanged >> oldEntity: anObject [

	oldEntity := anObject
]
