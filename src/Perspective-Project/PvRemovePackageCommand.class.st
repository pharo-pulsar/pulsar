Class {
	#name : #PvRemovePackageCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #'accessing - defaults' }
PvRemovePackageCommand class >> defaultDescription [

	^ 'Remove package or tag (and all its contexts)'
]

{ #category : #'accessing - defaults' }
PvRemovePackageCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: 'trash';
		yourself
]

{ #category : #'accessing - defaults' }
PvRemovePackageCommand class >> defaultName [

	^ 'Remove'
]

{ #category : #accessing }
PvRemovePackageCommand class >> defaultPriority [

	^ 210
]

{ #category : #initialization }
PvRemovePackageCommand class >> defaultShortcut [

	^ $x platformMeta
]

{ #category : #'default - groups' }
PvRemovePackageCommand class >> groups [

	^ #(action)
]

{ #category : #executing }
PvRemovePackageCommand >> execute [
	
	self halt
]
