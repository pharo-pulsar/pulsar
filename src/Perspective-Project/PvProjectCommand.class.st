"
A base command for projects
"
Class {
	#name : 'PvProjectCommand',
	#superclass : 'PvAction',
	#category : 'Perspective-Project-Command',
	#package : 'Perspective-Project',
	#tag : 'Command'
}

{ #category : 'default - groups' }
PvProjectCommand class >> commandGroupNew [
	<commandGroup: #actionNew>
	
	^ (PvCommandGroup named: 'New') asSpecGroup
		priority: 20;
		beDisplayedAsSubMenu;
		yourself
]

{ #category : 'default - groups' }
PvProjectCommand class >> commandGroupProject [
	<commandGroup: #project>
	
	^ (PvCommandGroup named: 'Project') asSpecGroup
		priority: 10;
		beDisplayedAsSubMenu;
		yourself
]

{ #category : 'testing' }
PvProjectCommand class >> isAbstract [

	^ super isAbstract or: [ self = PvProjectCommand ]
]
