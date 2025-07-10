Class {
	#name : 'DockObjectExplorerCollectionSlot',
	#superclass : 'DockObjectExplorerSlot',
	#category : 'Dock-Tool-ObjectExplorer',
	#package : 'Dock-Tool-ObjectExplorer'
}

{ #category : 'accessing' }
DockObjectExplorerCollectionSlot >> children [

	^ self object
		collect: [ :each | DockObjectExplorerInstance newObject: each ]
		as: OrderedCollection
]
