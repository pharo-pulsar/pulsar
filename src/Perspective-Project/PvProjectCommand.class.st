"
A base command for projects
"
Class {
	#name : #PvProjectCommand,
	#superclass : #PvCommand,
	#category : #'Perspective-Project'
}

{ #category : #'default - groups' }
PvProjectCommand class >> commandGroupProject [
	<commandGroup: #project>
	
	^ (PvCommandGroup named: 'Project') asSpecGroup
		priority: 10;
		beDisplayedAsGroup;
		yourself
]

{ #category : #testing }
PvProjectCommand class >> isAbstract [

	^ super isAbstract or: [ self = PvProjectCommand ]
]
