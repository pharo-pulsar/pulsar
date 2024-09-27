Class {
	#name : 'PvOpenProjectCommand',
	#superclass : 'PvProjectCommand',
	#category : 'Perspective-Project-Command',
	#package : 'Perspective-Project',
	#tag : 'Command'
}

{ #category : 'private' }
PvOpenProjectCommand >> allBaselines [
		
	^ BaselineOf allSubclasses sorted: #name ascending
	
		
]

{ #category : 'initialization' }
PvOpenProjectCommand >> defineAction [

	self priority: 1.
	self name: 'Open project'.
	self description: 'Open project'.
	self iconCompositeName: 'openProject'
]

{ #category : 'executing' }
PvOpenProjectCommand >> execute [
	| result |
	
	result := self application newSelect
		title: 'Open project';
		label: 'Select project';
		items: self allBaselines;
		display: [ :aClass | aClass name allButFirst: "'BaselineOf' size "10 ];
		displayIcon: [ :aClass | self application iconNamed: 'project' ];
		openModalWithParent: self context window.
		
	result ifNil: [ ^ self ].
	context activateProject: result
		
]
