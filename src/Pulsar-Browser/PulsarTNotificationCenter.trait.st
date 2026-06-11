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
PulsarTNotificationCenter >> basicNotificationCenter: anAnnouncer [
	
	"this is super hacky, but for now works"
	(anAnnouncer isKindOf: PulsarNotificationCenterDelegate) 
		ifTrue: [ notificationCenter := anAnnouncer ] 
		ifFalse: [
			(notificationCenter isKindOf: PulsarNotificationCenterDelegate)
				ifTrue: [ notificationCenter target: anAnnouncer ]
				ifFalse: [ notificationCenter := PulsarNotificationCenterDelegate on: anAnnouncer ] ]
]

{ #category : 'private' }
PulsarTNotificationCenter >> notificationCenter [

	^ notificationCenter
]

{ #category : 'private' }
PulsarTNotificationCenter >> notificationCenter: anAnnouncer [
	"made the delegation go a basic because some classes may override this but keep 
	 the behavior"
	self basicNotificationCenter: anAnnouncer
]

{ #category : 'initialization' }
PulsarTNotificationCenter >> registerToBrowser: aPulsarBrowser [

	self notificationCenter: aPulsarBrowser notificationCenter
]
