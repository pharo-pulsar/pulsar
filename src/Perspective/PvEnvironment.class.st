Class {
	#name : 'PvEnvironment',
	#superclass : 'Object',
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'testing' }
PvEnvironment >> hasPackageNamed: aString [ 
	
	self subclassResponsibility
]

{ #category : 'accessing' }
PvEnvironment >> name [

	^ self subclassResponsibility
]
