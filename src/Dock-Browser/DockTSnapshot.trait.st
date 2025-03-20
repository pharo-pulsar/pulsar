Trait {
	#name : 'DockTSnapshot',
	#category : 'Dock-Browser-Snapshot',
	#package : 'Dock-Browser',
	#tag : 'Snapshot'
}

{ #category : 'accessing - snapshot' }
DockTSnapshot >> snapshot [

	^ DockPanelSnapshot on: self
]
