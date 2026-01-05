"
A refactor context is responsible to deliver refactors (applied to a class or a method).  
It is more or less like a façade, in de sense that if works as a common entry point that will later execute refactoring drivers.  

It is needed because refactors can be executed in diferent contexts, e.g. from a `DockEditor`, `DockClassOutlineView` or `DockProjectView`.  
They are all the same refactors, but the data required to execute them is collected diferently.
"
Class {
	#name : 'DockRefactorContext',
	#superclass : 'Object',
	#instVars : [
		'owner'
	],
	#category : 'Dock-Browser-View-Refactoring',
	#package : 'Dock-Browser',
	#tag : 'View-Refactoring'
}

{ #category : 'instance creation' }
DockRefactorContext class >> on: aPresenter [

	^ self new 
		owner: aPresenter;
		yourself
]

{ #category : 'accessing' }
DockRefactorContext >> application [

	^ self owner application
]

{ #category : 'accessing' }
DockRefactorContext >> owner [

	^ owner
]

{ #category : 'initialization' }
DockRefactorContext >> owner: aPresenter [

	owner := aPresenter
]

{ #category : 'private' }
DockRefactorContext >> schedule: aBlock [

	self application schedule: aBlock
]
