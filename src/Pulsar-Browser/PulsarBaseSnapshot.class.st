"
`PulsarBaseSnapshot` is the abstract root of the snapshot hierarchy that lets Pulsar remember the state of its presenters between sessions. A snapshot captures what a presenter needs to come back the way the user left it, and it restores that state into a freshly instantiated presenter rather than the original one.

Each concrete snapshot is created from a live presenter with `on:`. Subclasses implement the capture step in `snapshot:`, and they extend `restoreTo:` to reapply their own state, usually after sending `super restoreTo:`. The `restorePriority` of a snapshot orders the restoration of sibling window snapshots when an application comes back up.

`PulsarBaseSnapshot` collaborates with the presenters it describes: each presenter answers its snapshot through `snapshot`, for example `PulsarBrowser>>snapshot` answers a `PulsarBrowserSnapshot`. It also collaborates with `PulsarApplicationSnapshot`, which holds the window snapshots of an application and restores them. `PulsarNULLSnapshot` is the no-op variant for presenters with no state worth keeping, and `SpPresenter>>snapshot` falls back to it.

Usage:

```smalltalk
| snapshot restored |
snapshot := browser snapshot.
restored := snapshot instantiateOn: application.
snapshot restoreTo: restored.
restored open.
```

`PulsarApplication>>start` restores the last saved application snapshot, and `PulsarDirectoryBrowserTest>>testSnapshotRestoresExpandedBranches` exercises a snapshot round trip.
"
Class {
	#name : 'PulsarBaseSnapshot',
	#superclass : 'Object',
	#category : 'Pulsar-Browser-Snapshot',
	#package : 'Pulsar-Browser',
	#tag : 'Snapshot'
}

{ #category : 'instance creation' }
PulsarBaseSnapshot class >> on: aPresenter [

	^ self new snapshot: aPresenter
]

{ #category : 'accessing' }
PulsarBaseSnapshot >> restorePriority [

	^ 100
]

{ #category : 'restoring' }
PulsarBaseSnapshot >> restoreTo: aPresenter [

]

{ #category : 'initialization' }
PulsarBaseSnapshot >> snapshot: anObject [

	self subclassResponsibility
]
