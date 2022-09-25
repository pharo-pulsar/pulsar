Class {
	#name : #PvRefreshProjectCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #'accessing - defaults' }
PvRefreshProjectCommand class >> defaultDescription [

	^ 'Refresh this project (reload configuration)'
]

{ #category : #'accessing - defaults' }
PvRefreshProjectCommand class >> defaultIconComposite [

	^ PvCompositeIcon new
		name: 'refresh';
		yourself
]

{ #category : #'accessing - defaults' }
PvRefreshProjectCommand class >> defaultName [

	^ 'Refresh project'
]

{ #category : #accessing }
PvRefreshProjectCommand class >> defaultPriority [

	^ 10
]

{ #category : #'default - groups' }
PvRefreshProjectCommand class >> groups [

	^ #(project)
]

{ #category : #testing }
PvRefreshProjectCommand class >> isVisibleInToolbar [

	^ true
]

{ #category : #executing }
PvRefreshProjectCommand >> execute [
	
	context refreshProject
]
