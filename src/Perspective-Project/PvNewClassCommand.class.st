Class {
	#name : #PvNewClassCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #'accessing - defaults' }
PvNewClassCommand class >> defaultDescription [

	^ 'Add a new class to the environment'
]

{ #category : #'accessing - defaults' }
PvNewClassCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: 'add';
		bottomRight: 'overlayClass';
		yourself
]

{ #category : #'accessing - defaults' }
PvNewClassCommand class >> defaultName [

	^ 'New class'
]

{ #category : #'accessing - defaults' }
PvNewClassCommand class >> defaultPriority [

	^ 0
]

{ #category : #default }
PvNewClassCommand class >> defaultToolbarGroup [

	^ #actions
]

{ #category : #testing }
PvNewClassCommand class >> isVisibleInToolbar [

	^ true
]

{ #category : #executing }
PvNewClassCommand >> execute [
	
	context doNewClass
]
