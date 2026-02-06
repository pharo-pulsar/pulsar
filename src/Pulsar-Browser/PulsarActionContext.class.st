"
An action context is responsible to deliver actions (applied to a class or a method).  
It is more or less like a façade, in de sense that if works as a common entry point that will later execute actions.  

It is needed because actions can be executed in diferent contexts, e.g. from a `PulsarEditor`, `PulsarClassOutlineView` or `PulsarProjectView`.  
They are all the same actions, but the data required to execute them is collected diferently.
"
Class {
	#name : 'PulsarActionContext',
	#superclass : 'Object',
	#instVars : [
		'owner'
	],
	#category : 'Pulsar-Browser-Base',
	#package : 'Pulsar-Browser',
	#tag : 'Base'
}

{ #category : 'instance creation' }
PulsarActionContext class >> on: aPresenter [

	^ self new 
		owner: aPresenter;
		yourself
]

{ #category : 'accessing' }
PulsarActionContext >> application [

	^ self owner application
]

{ #category : 'accessing' }
PulsarActionContext >> owner [

	^ owner
]

{ #category : 'initialization' }
PulsarActionContext >> owner: aPresenter [

	owner := aPresenter
]

{ #category : 'private' }
PulsarActionContext >> schedule: aBlock [

	self 
		deprecated: 'This is confusing, use #scheduleTask:' 
		transformWith:
			'`@receiver schedule: `@arg' -> 
			'`@receiver scheduleTask: `@arg'.

	^ self scheduleTask: aBlock
]

{ #category : 'private' }
PulsarActionContext >> scheduleJob: aBlock [

	self window scheduleJob: aBlock
]

{ #category : 'private' }
PulsarActionContext >> scheduleTask: aBlock [

	self application scheduleTask: aBlock
]

{ #category : 'accessing' }
PulsarActionContext >> window [

	^ self owner isWindow 
		ifTrue: [ self owner ] 
		ifFalse: [ self owner window ]
]
