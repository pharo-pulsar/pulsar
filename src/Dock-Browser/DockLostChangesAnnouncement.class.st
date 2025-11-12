Class {
	#name : 'DockLostChangesAnnouncement',
	#superclass : 'DockAnnouncement',
	#instVars : [
		'detector'
	],
	#category : 'Dock-Browser-Announcement',
	#package : 'Dock-Browser',
	#tag : 'Announcement'
}

{ #category : 'accessing' }
DockLostChangesAnnouncement >> detector [

	^ detector
]

{ #category : 'accessing' }
DockLostChangesAnnouncement >> detector: aLostChangesDetector [

	detector := aLostChangesDetector
]
