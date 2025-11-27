Trait {
	#name : 'DockTNotificationCenter',
	#instVars : [
		'notificationCenter'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'private' }
DockTNotificationCenter >> notificationCenter [

	^ notificationCenter
]

{ #category : 'private' }
DockTNotificationCenter >> notificationCenter: anAnnouncer [

	notificationCenter := anAnnouncer
]

{ #category : 'initialization' }
DockTNotificationCenter >> registerToDock: aDockBrowser [

	self notificationCenter: aDockBrowser notificationCenter
]
