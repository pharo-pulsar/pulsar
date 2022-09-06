"
A base command for projects
"
Class {
	#name : #PvProjectCommand,
	#superclass : #PvCommand,
	#category : #'Perspective-Project'
}

{ #category : #default }
PvProjectCommand class >> groups [

	^ #(project)
]

{ #category : #testing }
PvProjectCommand class >> isAbstract [

	^ super isAbstract or: [ self = PvProjectCommand ]
]
