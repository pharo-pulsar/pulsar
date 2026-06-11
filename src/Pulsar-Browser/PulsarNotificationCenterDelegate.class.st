"
A **delegate** for an Announcer that can have its target reassigned at runtime.

When a panel widget is detached and transferred to another browser, the notificationCenter of the presenter tree must change to the new browser's announcer. Instead of propagating the change to every nested presenter, all presenters share the same proxy instance. Updating the proxy's target reaches all holders automatically.

Not a proxy because I do not want to implement _doesNotUnderstand:_ in this case, because we need to know the identity of the object.
"
Class {
	#name : 'PulsarNotificationCenterDelegate',
	#superclass : 'Object',
	#instVars : [
		'target'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'instance creation' }
PulsarNotificationCenterDelegate class >> on: anAnnouncer [

	^ self new
		  target: anAnnouncer;
		  yourself
]

{ #category : 'forwarding' }
PulsarNotificationCenterDelegate >> announce: anAnnouncement [

	target ifNotNil: [ target announce: anAnnouncement ]
]

{ #category : 'forwarding' }
PulsarNotificationCenterDelegate >> suspendAllWhile: aBlock [

	target ifNotNil: [ target suspendAllWhile: aBlock ]
]

{ #category : 'accessing' }
PulsarNotificationCenterDelegate >> target [

	^ target
]

{ #category : 'accessing' }
PulsarNotificationCenterDelegate >> target: anAnnouncer [

	target := anAnnouncer
]

{ #category : 'forwarding' }
PulsarNotificationCenterDelegate >> unsubscribe: anObject [

	target ifNotNil: [ target unsubscribe: anObject ]
]

{ #category : 'forwarding' }
PulsarNotificationCenterDelegate >> when: anAnnouncementClass do: aBlock [

	target ifNotNil: [ target when: anAnnouncementClass do: aBlock ]
]

{ #category : 'forwarding' }
PulsarNotificationCenterDelegate >> when: anAnnouncementClass do: aBlock for: aSubscriber [

	target ifNotNil: [ target when: anAnnouncementClass do: aBlock for: aSubscriber ]
]

{ #category : 'forwarding' }
PulsarNotificationCenterDelegate >> when: anAnnouncementClass send: aSelector to: anObject [

	target ifNotNil: [ target when: anAnnouncementClass send: aSelector to: anObject ]
]
