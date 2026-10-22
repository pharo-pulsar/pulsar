"
`PulsarNULLSnapshot` is the neutral snapshot used when a presenter has no state worth preserving across an application restart. It exists so the snapshot protocol can be sent uniformly to every presenter: the default `SpPresenter>>snapshot` answers a null snapshot, and presenters that do have something to restore override `snapshot` with a concrete `PulsarBaseSnapshot` subclass.

Taking a null snapshot accepts the source presenter but records nothing. This keeps snapshot traversal free of special cases, so presenters that do not participate cost nothing while still fitting into the tree collected by `PulsarApplicationSnapshot` and the browser snapshots. Restoring one has no effect; it is simply a no-op within the enclosing restore.

It collaborates with `PulsarBaseSnapshot`, which defines the snapshot/restore protocol, and with the concrete application, browser, editor, and tool snapshots that collect and restore their child presenters. Use it as the default answer for presenters whose transient UI state should not survive a restart, and do not instantiate it directly when the inherited default already applies.

For example, `SpPresenter>>snapshot` answers `PulsarNULLSnapshot on: self`, whereas `PulsarBrowser>>snapshot` answers a `PulsarBrowserSnapshot`. When the application snapshot asks all of its windows for snapshots, the null entries are later restored as no-ops.
"
Class {
	#name : 'PulsarNULLSnapshot',
	#superclass : 'PulsarBaseSnapshot',
	#category : 'Pulsar-Browser-Snapshot',
	#package : 'Pulsar-Browser',
	#tag : 'Snapshot'
}

{ #category : 'initialization' }
PulsarNULLSnapshot >> snapshot: aPresenter [
	"do nothing"
]
