Class {
	#name : #PvNewTraitCommand,
	#superclass : #PvCommand,
	#category : #'Perspective-Class-Model'
}

{ #category : #'accessing - defaults' }
PvNewTraitCommand class >> defaultDescription [

	^ 'Add a new class to the environment'
]

{ #category : #'accessing - defaults' }
PvNewTraitCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: 'trait';
		addNew;
		yourself
]

{ #category : #'accessing - defaults' }
PvNewTraitCommand class >> defaultName [

	^ 'New trait'
]

{ #category : #executing }
PvNewTraitCommand >> execute [
	
	context doNewTrait
]
