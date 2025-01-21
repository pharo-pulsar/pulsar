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

{ #category : 'visiting' }
DockMultiProjectModel >> accept: aVisitor [

	^ aVisitor visitProjectModel: aVisitor
]

{ #category : 'actions' }
DockMultiProjectModel >> addProject: aBaselineClass [
	| newProjectModel |

	newProjectModel := (PvProjectModel 
		newEntity: aBaselineClass 
		environment: self environmentModel).
	
	(projectModels includes: newProjectModel) ifTrue: [ ^ self ].
	
	projectModels := projectModels copyWith: newProjectModel
]

{ #category : 'accessing' }
DockMultiProjectModel >> children [

	^ projectModels
]

{ #category : 'accessing' }
DockMultiProjectModel >> findPathForClassModel: aClassModel [
	| path |
	
	"{ self. aClassModel } inspect."
	self children withIndexDo: [ :each :index |
		path := self 
			pathTo: { aClassModel packageName. aClassModel packageTagName }
			in: each children.
		path ifNotEmpty: [
			^ { index }, 
			  (path collect: #value), 
			  (self 
					findRecursivelyPathForClassModel: aClassModel 
					inNode: path last key) ] ].
	^ nil
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
