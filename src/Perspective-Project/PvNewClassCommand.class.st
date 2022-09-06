Class {
	#name : #PvNewClassCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #'accessing - defaults' }
PvNewClassCommand class >> defaultDescription [

	^ 'Add a new class to the environment'
]

{ #category : #'accessing - defaults' }
PvNewClassCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: 'add';
		bottomRight: 'overlayClass';
		yourself
]

{ #category : #'accessing - defaults' }
PvNewClassCommand class >> defaultName [

	^ 'New class'
]

{ #category : #'accessing - defaults' }
PvNewClassCommand class >> defaultPriority [

	^ 10
]

{ #category : #default }
PvNewClassCommand class >> groups [

	^ #(actions)
]

{ #category : #testing }
PvNewClassCommand class >> isVisibleInToolbar [

	^ true
]

{ #category : #executing }
PvNewClassCommand >> execute [
	"context doNewClass"
	
	| items parentModel |

	items := context selectedEntitiesInPath.
	items ifEmpty: [ self error: 'TODO' ].

	parentModel := items reversed detect: [ :each | each isPackageOrTag ].
		
	context activateWith: (PvNewClassModel
		newEnvironment: self model environmentModel
		entity: (PvNewClassTemplate new
			parentModel: parentModel;
			yourself))
]
