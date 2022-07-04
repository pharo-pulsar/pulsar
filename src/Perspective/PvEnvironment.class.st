Class {
	#name : #PvEnvironment,
	#superclass : #Object,
	#category : #'Perspective-Model'
}

{ #category : #testing }
PvEnvironment >> hasPackageNamed: aString [ 
	
	self subclassResponsibility
]

{ #category : #accessing }
PvEnvironment >> name [

	^ self subclassResponsibility
]
