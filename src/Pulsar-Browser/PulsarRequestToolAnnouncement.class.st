"
I represent a request to open a tool in a Pulsar browser.

I exist so that any part of the IDE can ask for a tool to be opened without knowing which browser will host it. I carry the model the tool should work on, while my concrete subclasses name the presenter class to instantiate. A browser listening to me adds that presenter with my model, and an already-open instance can be raised instead of duplicated when the request reports itself as unique.

My main collaborators are the notification center that broadcasts me, `PulsarBaseBrowser`, which turns me into a tool, and the presenters named by my subclasses, such as `PulsarPlayground`, `PulsarLLMChatConsole`, `PulsarSingleProjectView` and `PulsarRepositoryRemotesView`.

For example:

```smalltalk
browser notificationCenter announce: (
	PulsarRequestProjectAnnouncement on: aProjectModel)
```

Requests are typically created with `on:` when the model is already available, or with `new` followed by `model:` when it is built at the call site.
"
Class {
	#name : 'PulsarRequestToolAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'model'
	],
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'instance creation' }
PulsarRequestToolAnnouncement class >> on: anObject [

	^ self new 
		model: anObject;
		yourself
]

{ #category : 'testing' }
PulsarRequestToolAnnouncement >> isUnique [
	"override is there can not be multiple versions of requested tool"

	^ false
]

{ #category : 'accessing' }
PulsarRequestToolAnnouncement >> model [

	^ model
]

{ #category : 'accessing' }
PulsarRequestToolAnnouncement >> model: anObject [

	model := anObject
]

{ #category : 'accessing' }
PulsarRequestToolAnnouncement >> toolClass [

	self subclassResponsibility
]
