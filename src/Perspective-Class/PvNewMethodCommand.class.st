Class {
	#name : #PvNewMethodCommand,
	#superclass : #PvClassCommand,
	#category : #'Perspective-Class-Command'
}

{ #category : #'accessing - defaults' }
PvNewMethodCommand class >> defaultDescription [

	^ 'Add a method to current class/trait'
]

{ #category : #'accessing - defaults' }
PvNewMethodCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: 'add';
		topRight: 'overlayClass';
		bottomRight: 'overlayMethod';
		yourself
]

{ #category : #'accessing - defaults' }
PvNewMethodCommand class >> defaultName [

	^ 'Add method'
]

{ #category : #accessing }
PvNewMethodCommand class >> defaultPriority [

	^ 10
]
