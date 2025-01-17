Class {
	#name : 'DockMultiProjectModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'projectModels'
	],
	#category : 'Dock-Browser-View-Project',
	#package : 'Dock-Browser',
	#tag : 'View-Project'
}

{ #category : 'instance creation' }
DockMultiProjectModel class >> newEnvironment: anEnvironmentModel [

	^ self newEnvironment: anEnvironmentModel entity: nil
]

{ #category : 'actions' }
DockMultiProjectModel >> addProject: aBaselineClass [

	projectModels := projectModels copyWith: (PvProjectModel 
		newEntity: aBaselineClass 
		environment: self environmentModel)
]

{ #category : 'accessing' }
DockMultiProjectModel >> children [

	^ projectModels
]

{ #category : 'private' }
DockMultiProjectModel >> findRecursivelyPathForClassModel: aClassModel inNode: aNode [
	"finds a subpath for a class model starting in a node. This is like this 
	 because after the tag, the structure will be a tree of nodes (because this 
	 is organised hierarchicaly)"
	
	aNode children withIndexDo: [ :each :index | 
		each realModel = aClassModel 
			ifTrue: [ ^ { index } ].
		(self findRecursivelyPathForClassModel: aClassModel inNode: each)
			ifNotEmpty: [ :subPath | ^ { index }, subPath ] ].
		
	^ #()
]

{ #category : 'initialization' }
DockMultiProjectModel >> initialize [

	super initialize.
	projectModels := #()
]

{ #category : 'accessing' }
DockMultiProjectModel >> name [

	^ 'Projects'
]

{ #category : 'private' }
DockMultiProjectModel >> pathTo: aPath in: aCollection [
	| segment |

	aPath ifEmpty: [ ^ #() ].

	segment := aPath first.
	aCollection withIndexDo: [ :each :index |
		each name = segment ifTrue: [ 
			^ { each -> index }, (self pathTo: aPath allButFirst in: each children ) ] ].

	^ #()
]

{ #category : 'actions' }
DockMultiProjectModel >> removeProjectModel: aModel [

	projectModels := projectModels copyWithout: aModel
]
