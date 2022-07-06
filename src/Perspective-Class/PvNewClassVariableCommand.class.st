Class {
	#name : #PvNewClassVariableCommand,
	#superclass : #PvClassCommand,
	#category : #'Perspective-Class-Command'
}

{ #category : #'accessing - defaults' }
PvNewClassVariableCommand class >> defaultDescription [

	^ 'Add a variable (class side) to current class/trait'
]

{ #category : #'accessing - defaults' }
PvNewClassVariableCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: 'add';
		topRight: 'overlayClass';
		bottomRight: 'overlayVariable';
		yourself
]

{ #category : #'accessing - defaults' }
PvNewClassVariableCommand class >> defaultName [

	^ 'Add class variable'
]

{ #category : #accessing }
PvNewClassVariableCommand class >> defaultPriority [

	^ 110
]
