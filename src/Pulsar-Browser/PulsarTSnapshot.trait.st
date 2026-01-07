Trait {
	#name : 'PulsarTSnapshot',
	#category : 'Pulsar-Browser-Snapshot',
	#package : 'Pulsar-Browser',
	#tag : 'Snapshot'
}

{ #category : 'accessing - snapshot' }
PulsarTSnapshot >> snapshot [

	^ PulsarPanelSnapshot on: self
]
