Class {
	#name : #PvNewVariableCommand,
	#superclass : #PvClassCommand,
	#category : #'Perspective-Class-Command'
}

{ #category : #'accessing - defaults' }
PvNewVariableCommand class >> defaultDescription [

	^ 'Add a variable to current class/trait'
]

{ #category : #'accessing - defaults' }
PvNewVariableCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: 'add';
		bottomRight: 'overlayVariable';
		yourself
]

{ #category : #'accessing - defaults' }
PvNewVariableCommand class >> defaultName [

	^ 'Add variable'
]

{ #category : #accessing }
PvNewVariableCommand class >> defaultPriority [

	^ 100
]

{ #category : #default }
PvNewVariableCommand class >> defaultToolbarGroup [

	^ #action
]

{ #category : #testing }
PvNewVariableCommand class >> isVisibleInToolbar [

	^ true
]
