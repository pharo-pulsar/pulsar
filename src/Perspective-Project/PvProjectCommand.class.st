Class {
	#name : #PvProjectCommand,
	#superclass : #PvCommand,
	#category : #'Perspective-Project'
}

{ #category : #default }
PvProjectCommand class >> defaultToolbarGroup [

	^ #project
]

{ #category : #testing }
PvProjectCommand class >> isAbstract [

	^ super isAbstract or: [ self = PvProjectCommand ]
]
