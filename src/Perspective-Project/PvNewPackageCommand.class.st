Class {
	#name : #PvNewPackageCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #'accessing - defaults' }
PvNewPackageCommand class >> defaultDescription [

	^ 'Add a new package to the environment'
]

{ #category : #'accessing - defaults' }
PvNewPackageCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: 'addFolder';
		"bottomRight: 'overlayPackage';"
		yourself
]

{ #category : #'accessing - defaults' }
PvNewPackageCommand class >> defaultName [

	^ 'New package'
]

{ #category : #'accessing - defaults' }
PvNewPackageCommand class >> defaultPriority [

	^ 0
]

{ #category : #default }
PvNewPackageCommand class >> groups [

	^ #(actions)
]

{ #category : #testing }
PvNewPackageCommand class >> isVisibleInToolbar [

	^ true
]

{ #category : #executing }
PvNewPackageCommand >> execute [
	
	context doNewPackage
]
