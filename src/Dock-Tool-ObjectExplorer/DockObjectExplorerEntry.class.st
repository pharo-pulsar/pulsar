Class {
	#name : 'DockObjectExplorerEntry',
	#superclass : 'Object',
	#instVars : [
		'object'
	],
	#category : 'Dock-Tool-ObjectExplorer',
	#package : 'Dock-Tool-ObjectExplorer'
}

{ #category : 'instance creation' }
DockObjectExplorerEntry class >> newObject: anObject [

	^ self new 
		object: anObject;
		yourself
]

{ #category : 'accessing' }
DockObjectExplorerEntry >> children [

	^ self object class slots 
		collect: [ :eachSlot |
			DockObjectExplorerSlot 
				newObject: (eachSlot read: self object)
				slot: eachSlot ]
]

{ #category : 'accessing' }
DockObjectExplorerEntry >> label [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
DockObjectExplorerEntry >> object [

	^ object
]

{ #category : 'accessing' }
DockObjectExplorerEntry >> object: anObject [

	object := anObject
]

{ #category : 'evaluating' }
DockObjectExplorerEntry >> value [ 

	^ self object asString
]
