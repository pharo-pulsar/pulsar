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

{ #category : 'private - announcing' }
DockTNotificationCenter >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (DockModelActivated newValue: anEntity realModel)
]

{ #category : 'private - announcing' }
DockTNotificationCenter >> notifyEntityChanged: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (DockModelChanged newValue: anEntity realModel)
]

{ #category : 'private - announcing' }
DockTNotificationCenter >> notifyEntityChanged: anEntity oldEntity: oldEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (DockModelChanged 
		newValue: anEntity realModel
		old: oldEntity realModel)
]

{ #category : 'private - announcing' }
DockTNotificationCenter >> notifyEntityRemoved: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (DockModelRemoved newValue: anEntity realModel)
]

{ #category : 'private - announcing' }
DockTNotificationCenter >> notifySelectEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (DockModelSelected newValue: anEntity realModel)
]

{ #category : 'initialization' }
DockTNotificationCenter >> registerToDock: aDockBrowser [

	self notificationCenter: aDockBrowser notificationCenter 
]
