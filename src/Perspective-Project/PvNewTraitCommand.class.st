Class {
	#name : #PvNewTraitCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #'accessing - defaults' }
PvNewTraitCommand class >> defaultDescription [

	^ 'Add a new trait to the environment'
]

{ #category : #'accessing - defaults' }
PvNewTraitCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: 'add';
		bottomRight: 'overlayTrait';
		yourself
]

{ #category : #'accessing - defaults' }
PvNewTraitCommand class >> defaultName [

	^ 'New trait'
]

{ #category : #accessing }
PvNewTraitCommand class >> defaultPriority [

	^ 120
]

{ #category : #'default - groups' }
PvNewTraitCommand class >> groups [

	^ #(action)
]

{ #category : #testing }
PvNewTraitCommand class >> isVisibleInToolbar [

	^ true
]

{ #category : #executing }
PvNewTraitCommand >> execute [
	
	context doNewTrait
]
