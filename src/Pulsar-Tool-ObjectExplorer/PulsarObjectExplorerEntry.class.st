Class {
	#name : 'PulsarObjectExplorerEntry',
	#superclass : 'Object',
	#instVars : [
		'object'
	],
	#category : 'Pulsar-Tool-ObjectExplorer',
	#package : 'Pulsar-Tool-ObjectExplorer'
}

{ #category : 'instance creation' }
PulsarObjectExplorerEntry class >> newObject: anObject [

	^ self new 
		object: anObject;
		yourself
]

{ #category : 'accessing' }
PulsarObjectExplorerEntry >> children [

	^ self object class allSlots 
		collect: [ :eachSlot |
			PulsarObjectExplorerSlot 
				newObject: (eachSlot read: self object)
				slot: eachSlot ]
]

{ #category : 'accessing' }
PulsarObjectExplorerEntry >> label [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
PulsarObjectExplorerEntry >> object [

	^ object
]

{ #category : 'accessing' }
PulsarObjectExplorerEntry >> object: anObject [

	object := anObject
]

{ #category : 'evaluating' }
PulsarObjectExplorerEntry >> value [ 

	^ self object asString
]
