Class {
	#name : 'PulsarObjectExplorerCollectionSlot',
	#superclass : 'PulsarObjectExplorerSlot',
	#category : 'Pulsar-Tool-ObjectExplorer',
	#package : 'Pulsar-Tool-ObjectExplorer'
}

{ #category : 'accessing' }
PulsarObjectExplorerCollectionSlot >> children [

	^ self object
		collect: [ :each | PulsarObjectExplorerInstance newObject: each ]
		as: OrderedCollection
]
