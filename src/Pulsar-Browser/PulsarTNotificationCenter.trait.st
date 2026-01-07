Trait {
	#name : 'PulsarTNotificationCenter',
	#instVars : [
		'notificationCenter'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'private' }
PulsarTNotificationCenter >> notificationCenter [

	^ notificationCenter
]

{ #category : 'private' }
PulsarTNotificationCenter >> notificationCenter: anAnnouncer [

	notificationCenter := anAnnouncer
]

{ #category : 'initialization' }
PulsarTNotificationCenter >> registerToPulsar: aPulsarBrowser [

	self notificationCenter: aPulsarBrowser notificationCenter
]
