Class {
	#name : #PvOpenProjectCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #'accessing - defaults' }
PvOpenProjectCommand class >> defaultDescription [

	^ 'Open a project'
]

{ #category : #'accessing - defaults' }
PvOpenProjectCommand class >> defaultIconComposite [

	^ PvCompositeIcon new
		name: 'openProject';
		yourself
]

{ #category : #'accessing - defaults' }
PvOpenProjectCommand class >> defaultName [

	^ 'Open project'
]

{ #category : #accessing }
PvOpenProjectCommand class >> defaultPriority [

	^ 1
]

{ #category : #'default - groups' }
PvOpenProjectCommand class >> groups [

	^ #(project)
]

{ #category : #testing }
PvOpenProjectCommand class >> isVisibleInToolbar [

	^ true
]

{ #category : #executing }
PvOpenProjectCommand >> execute [
	
	context doOpenProject
]
