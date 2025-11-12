Class {
	#name : 'DockModelVisitor',
	#superclass : 'Object',
	#instVars : [
		'owner'
	],
	#category : 'Dock-Browser-View-Project',
	#package : 'Dock-Browser',
	#tag : 'View-Project'
}

{ #category : 'instance creation' }
DockModelVisitor class >> on: anOwner [

	^ self new 
		owner: anOwner;
		yourself
]

{ #category : 'accessing' }
DockModelVisitor >> owner [

	^ owner
]

{ #category : 'accessing' }
DockModelVisitor >> owner: anObject [

	owner := anObject
]

{ #category : 'visiting' }
DockModelVisitor >> visit: aModel [

	^ aModel accept: self
]

{ #category : 'visiting' }
DockModelVisitor >> visitClassModel: aModel [

]

{ #category : 'visiting' }
DockModelVisitor >> visitMethodModel: aModel [

]

{ #category : 'visiting' }
DockModelVisitor >> visitPackageModel: aModel [

]

{ #category : 'visiting' }
DockModelVisitor >> visitPackageTagModel: aModel [

]

{ #category : 'visiting' }
DockModelVisitor >> visitProjectModel: aModel [

]
