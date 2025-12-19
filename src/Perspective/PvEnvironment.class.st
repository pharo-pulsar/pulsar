Class {
	#name : 'PvEnvironment',
	#superclass : 'Object',
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'query' }
PvEnvironment >> allClassesAndTraits [

	^ self subclassResponsibility
]

{ #category : 'converting' }
PvEnvironment >> asRBNamespace [

	self subclassResponsibility
]

{ #category : 'testing' }
PvEnvironment >> hasPackageNamed: aString [ 
	
	self subclassResponsibility
]

{ #category : 'accessing' }
PvEnvironment >> name [

	^ self subclassResponsibility
]
