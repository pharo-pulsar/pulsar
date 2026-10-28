"
I am the error variant of the notifications that the Pulsar browser displays to the user.

My responsibility is to carry an exception as my payload, so that the browser can both report it and let the user dig into it. I add no behavior of my own — I inherit my single value and its creation from `PulsarNotificationAnnouncement`.

My main collaborator is `PulsarBaseBrowser`, which subscribes to me on its announcer and, in `eventErrorNotification:`, logs my value and shows it as a toast with a Debug button that passes my value back to the debugger.

I am typically created and announced in a single expression, as done in `PulsarTaskAnnouncer>>announceError:`:

```smalltalk
announcer announce: (PulsarErrorAnnouncement newValue: anException)
```
"
Class {
	#name : 'PulsarErrorAnnouncement',
	#superclass : 'PulsarNotificationAnnouncement',
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}
