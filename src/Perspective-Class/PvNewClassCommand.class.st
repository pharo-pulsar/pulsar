Class {
	#name : #PvNewClassCommand,
	#superclass : #PvCommand,
	#category : #'Perspective-Class-Model'
}

{ #category : #'accessing - defaults' }
PvNewClassCommand class >> defaultDescription [

	^ 'Add a new class to the environment'
]

{ #category : #'accessing - defaults' }
PvNewClassCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: 'class';
		addNew;
		yourself
]

{ #category : #'accessing - defaults' }
PvNewClassCommand class >> defaultName [

	^ 'New class'
]

{ #category : #executing }
PvNewClassCommand >> execute [
	
	context doNewClass
]
