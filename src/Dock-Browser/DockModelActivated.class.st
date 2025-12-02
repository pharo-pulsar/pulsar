Class {
	#name : 'DockModelActivated',
	#superclass : 'DockAnnouncement',
	#instVars : [
		'selection'
	],
	#category : 'Dock-Browser-Announcement',
	#package : 'Dock-Browser',
	#tag : 'Announcement'
}

{ #category : 'testing' }
DockModelActivated >> hasSelection [

	^ self selection isNotNil
]

{ #category : 'accessing' }
DockModelActivated >> selection [

	^ selection
]

{ #category : 'accessing' }
DockModelActivated >> selection: anInterval [

	selection := anInterval
]
