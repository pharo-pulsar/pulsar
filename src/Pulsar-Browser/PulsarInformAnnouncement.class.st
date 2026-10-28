"
I am the informational variant of the notifications that the Pulsar browser displays to the user.

My responsibility is to carry a plain message string as my payload, so that the browser can present it without the emphasis reserved for warnings and errors. I add no behavior of my own — I inherit my single value and its creation from `PulsarNotificationAnnouncement`.

My main collaborator is `PulsarBaseBrowser`, which subscribes to me on its announcer and, in `eventInformNotification:`, shows my value as a toast.

I am typically created and announced in a single expression, as done in `PulsarTaskAnnouncer>>announceInform:`:

```smalltalk
announcer announce: (PulsarInformAnnouncement newValue: 'Your changes were saved')
```
"
Class {
	#name : 'PulsarInformAnnouncement',
	#superclass : 'PulsarNotificationAnnouncement',
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}
