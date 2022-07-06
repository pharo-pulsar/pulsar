Class {
	#name : #PvProjectCommand,
	#superclass : #PvCommand,
	#category : #'Perspective-Project'
}

{ #category : #testing }
PvProjectCommand class >> isAbstract [

	^ super isAbstract or: [ self = PvProjectCommand ]
]
