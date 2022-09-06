Class {
	#name : #PvNewClassMethodCommand,
	#superclass : #PvClassCommand,
	#category : #'Perspective-Class-Command'
}

{ #category : #'accessing - defaults' }
PvNewClassMethodCommand class >> defaultDescription [

	^ 'Add a method (class side) to current class/trait'
]

{ #category : #'accessing - defaults' }
PvNewClassMethodCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: 'add';
		bottomRight: 'overlayMethod';
		yourself
]

{ #category : #'accessing - defaults' }
PvNewClassMethodCommand class >> defaultName [

	^ 'Add class method'
]

{ #category : #accessing }
PvNewClassMethodCommand class >> defaultPriority [

	^ 20
]

{ #category : #default }
PvNewClassMethodCommand class >> groups [

	^ #(action)
]
