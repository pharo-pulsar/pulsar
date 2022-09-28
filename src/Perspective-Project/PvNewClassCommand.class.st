Class {
	#name : #PvNewClassCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #initialization }
PvNewClassCommand >> defineAction [

	self priority: 110.
	self name: 'New class'.
	self description: 'Add a new class to the environment'.
	self iconCompositeName: 'new-file'.
	self menuGroup: #actionNew.
	self toolbarGroup: #actionNew
]

{ #category : #executing }
PvNewClassCommand >> execute [
	"context doNewClass"
	| items parentModel |

	items := context selectedEntitiesInPath.
	items ifEmpty: [ self error: 'TODO' ].

	parentModel := items reversed detect: [ :each | each isPackageOrTag ].
		
	context activateWith: (PvClassModel
		newEnvironment: self model environmentModel
		entity: (PvNewClassTemplate new
			parentModel: parentModel;
			yourself))
]
