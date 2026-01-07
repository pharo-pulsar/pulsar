Class {
	#name : 'PulsarObjectExplorerSlot',
	#superclass : 'PulsarObjectExplorerEntry',
	#instVars : [
		'slot'
	],
	#category : 'Pulsar-Tool-ObjectExplorer',
	#package : 'Pulsar-Tool-ObjectExplorer'
}

{ #category : 'instance creation' }
PulsarObjectExplorerSlot class >> newObject: anObject slot: aSlot [

	^ (self realClassFor: anObject) new 
		object: anObject;
		slot: aSlot;
		yourself
]

{ #category : 'instance creation' }
PulsarObjectExplorerSlot class >> realClassFor: anObject [

	anObject isCollection
		ifTrue: [ ^ PulsarObjectExplorerCollectionSlot ].

	^ PulsarObjectExplorerInstanceSlot
]

{ #category : 'accessing' }
PulsarObjectExplorerSlot >> label [

	^ self slot name
]

{ #category : 'accessing' }
PulsarObjectExplorerSlot >> slot [

	^ slot
]

{ #category : 'accessing' }
PulsarObjectExplorerSlot >> slot: aSlot [

	slot := aSlot
]
