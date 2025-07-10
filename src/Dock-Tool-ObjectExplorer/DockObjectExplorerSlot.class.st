Class {
	#name : 'DockObjectExplorerSlot',
	#superclass : 'DockObjectExplorerEntry',
	#instVars : [
		'slot'
	],
	#category : 'Dock-Tool-ObjectExplorer',
	#package : 'Dock-Tool-ObjectExplorer'
}

{ #category : 'instance creation' }
DockObjectExplorerSlot class >> newObject: anObject slot: aSlot [

	^ (self realClassFor: anObject) new 
		object: anObject;
		slot: aSlot;
		yourself
]

{ #category : 'instance creation' }
DockObjectExplorerSlot class >> realClassFor: anObject [

	anObject isCollection
		ifTrue: [ ^ DockObjectExplorerCollectionSlot ].

	^ DockObjectExplorerInstanceSlot
]

{ #category : 'accessing' }
DockObjectExplorerSlot >> label [

	^ self slot name
]

{ #category : 'accessing' }
DockObjectExplorerSlot >> slot [

	^ slot
]

{ #category : 'accessing' }
DockObjectExplorerSlot >> slot: aSlot [

	slot := aSlot
]
