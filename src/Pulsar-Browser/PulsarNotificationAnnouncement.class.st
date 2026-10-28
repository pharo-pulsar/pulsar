"
I am the base class for the user-facing notifications that the Pulsar browser displays.

My responsibility is to carry a single payload — typically a message string or an error, though any object may serve — and let the browser route notifications by their kind. My concrete subclasses `PulsarInformAnnouncement`, `PulsarWarningAnnouncement` and `PulsarErrorAnnouncement` represent the inform, warning and error variants respectively.

My main collaborator is `PulsarBaseBrowser`, which subscribes to my subclasses on its announcer and renders each one as a panel toast (see `PulsarBaseBrowser>>registerToEvents` and its `eventInformNotification:` handler).

Creating and announcing a notification is usually a single expression, as done in `PulsarTaskAnnouncer>>announceWarning:`:

```smalltalk
announcer announce: (PulsarWarningAnnouncement newValue: aWarning)
```
"
Class {
	#name : 'PulsarNotificationAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'value'
	],
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'instance creation' }
PulsarNotificationAnnouncement class >> newValue: aNotification [

	^ self new value: aNotification
]

{ #category : 'accessing' }
PulsarNotificationAnnouncement >> value [

	^ value
]

{ #category : 'accessing' }
PulsarNotificationAnnouncement >> value: aNotification [

	value := aNotification
]
