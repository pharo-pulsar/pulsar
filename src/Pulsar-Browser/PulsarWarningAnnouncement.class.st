"
I am the warning variant of the notifications that the Pulsar browser displays to the user.

My responsibility is to carry a warning object as my payload, so that the browser can present it distinctly from informs and errors. I add no behavior of my own — I inherit my single value and its creation from `PulsarNotificationAnnouncement`.

My main collaborator is `PulsarBaseBrowser`, which subscribes to me on its announcer and, in `eventWarningNotification:`, logs my value's message text and shows it as an orange toast.

I am typically created and announced in a single expression, as done in `PulsarTaskAnnouncer>>announceWarning:`:

```smalltalk
announcer announce: (PulsarWarningAnnouncement newValue: aWarning)
```
"
Class {
	#name : 'PulsarWarningAnnouncement',
	#superclass : 'PulsarNotificationAnnouncement',
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}
