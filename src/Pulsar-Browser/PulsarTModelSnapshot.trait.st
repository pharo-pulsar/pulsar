"
Providing a stub to prepare models to be snapshot
"
Trait {
	#name : 'PulsarTModelSnapshot',
	#category : 'Pulsar-Browser-Snapshot',
	#package : 'Pulsar-Browser',
	#tag : 'Snapshot'
}

{ #category : 'private' }
PulsarTModelSnapshot >> prepareForSnapshot [
	"This message is used when a model will be snapshot, 
	 use it to clean up what is not need/want to be kept"
]
