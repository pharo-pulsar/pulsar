Class {
	#name : 'DockMultiProjectModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'projectModels'
	],
	#category : 'Dock-Browser-Model',
	#package : 'Dock-Browser',
	#tag : 'Model'
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

{ #category : 'initialization' }
DockMultiProjectModel >> initialize [

	super initialize.
	projectModels := #()
]

{ #category : 'accessing' }
DockMultiProjectModel >> name [

	^ 'Projects'
]

{ #category : 'actions' }
DockMultiProjectModel >> removeProjectModel: aModel [

	projectModels := projectModels copyWithout: aModel
]
