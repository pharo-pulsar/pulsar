Class {
	#name : 'PvMultiProjectModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'projectModels'
	],
	#category : 'Dock-Browser-Base',
	#package : 'Dock-Browser',
	#tag : 'Base'
}

{ #category : 'instance creation' }
PvMultiProjectModel class >> newEnvironment: anEnvironmentModel [

	^ self newEnvironment: anEnvironmentModel entity: nil
]

{ #category : 'actions' }
PvMultiProjectModel >> addProject: aBaselineClass [

	projectModels := projectModels copyWith: (PvProjectModel 
		newEntity: aBaselineClass 
		environment: self environmentModel)
]

{ #category : 'accessing' }
PvMultiProjectModel >> children [

	^ projectModels
]

{ #category : 'initialization' }
PvMultiProjectModel >> initialize [

	super initialize.
	projectModels := #()
]

{ #category : 'accessing' }
PvMultiProjectModel >> name [

	^ 'Projects'
]
