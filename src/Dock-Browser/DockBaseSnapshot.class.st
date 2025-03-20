Class {
	#name : 'DockBaseSnapshot',
	#superclass : 'Object',
	#category : 'Dock-Browser-Snapshot',
	#package : 'Dock-Browser',
	#tag : 'Snapshot'
}

{ #category : 'instance creation' }
DockBaseSnapshot class >> on: aPresenter [

	^ self new snapshot: aPresenter
]

{ #category : 'restoring' }
DockBaseSnapshot >> restoreTo: aPresenter [

]

{ #category : 'initialization' }
DockBaseSnapshot >> snapshot: anObject [

	self subclassResponsibility
]
