"
A refactor context is responsible to deliver refactors (applied to a class or a method).  
It is more or less like a façade, in de sense that if works as a common entry point that will later execute refactoring drivers.  

It is needed because refactors can be executed in diferent contexts, e.g. from a `PulsarEditor`, `PulsarClassOutlineView` or `PulsarProjectView`.  
They are all the same refactors, but the data required to execute them is collected diferently.
"
Class {
	#name : 'PulsarRefactorContext',
	#superclass : 'Object',
	#instVars : [
		'owner'
	],
	#category : 'Pulsar-Browser-View-Refactoring',
	#package : 'Pulsar-Browser',
	#tag : 'View-Refactoring'
}

{ #category : 'instance creation' }
PulsarRefactorContext class >> on: aPresenter [

	^ self new 
		owner: aPresenter;
		yourself
]

{ #category : 'accessing' }
PulsarRefactorContext >> application [

	^ self owner application
]

{ #category : 'accessing' }
PulsarRefactorContext >> owner [

	^ owner
]

{ #category : 'initialization' }
PulsarRefactorContext >> owner: aPresenter [

	owner := aPresenter
]

{ #category : 'private' }
PulsarRefactorContext >> schedule: aBlock [

	self 
		deprecated: 'This is confusing, use #scheduleTask:' 
		transformWith:
			'`@receiver schedule: `@arg' -> 
			'`@receiver scheduleTask: `@arg'.

	^ self scheduleTask: aBlock
]

{ #category : 'private' }
PulsarRefactorContext >> scheduleTask: aBlock [

	self application scheduleTask: aBlock
]
