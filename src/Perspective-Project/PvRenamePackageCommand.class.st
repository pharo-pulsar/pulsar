Class {
	#name : #PvRenamePackageCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #'accessing - defaults' }
PvRenamePackageCommand class >> defaultDescription [

	^ 'Rename package or tag'
]

{ #category : #'accessing - defaults' }
PvRenamePackageCommand class >> defaultIconComposite [

	^ nil
]

{ #category : #'accessing - defaults' }
PvRenamePackageCommand class >> defaultName [

	^ 'Rename'
]

{ #category : #accessing }
PvRenamePackageCommand class >> defaultPriority [

	^ 200
]

{ #category : #'default - groups' }
PvRenamePackageCommand class >> groups [

	^ #(action)
]

{ #category : #executing }
PvRenamePackageCommand >> execute [
	
	self halt
]
