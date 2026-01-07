Class {
	#name : 'PulsarModelVisitor',
	#superclass : 'Object',
	#instVars : [
		'owner'
	],
	#category : 'Pulsar-Browser-Base',
	#package : 'Pulsar-Browser',
	#tag : 'Base'
}

{ #category : 'instance creation' }
PulsarModelVisitor class >> on: anOwner [

	^ self new 
		owner: anOwner;
		yourself
]

{ #category : 'accessing' }
PulsarModelVisitor >> owner [

	^ owner
]

{ #category : 'accessing' }
PulsarModelVisitor >> owner: anObject [

	owner := anObject
]

{ #category : 'visiting' }
PulsarModelVisitor >> visit: aModel [

	^ aModel accept: self
]

{ #category : 'visiting' }
PulsarModelVisitor >> visitClassModel: aModel [

]

{ #category : 'visiting' }
PulsarModelVisitor >> visitMethodModel: aModel [

]

{ #category : 'visiting' }
PulsarModelVisitor >> visitModel: aModel [
]

{ #category : 'visiting' }
PulsarModelVisitor >> visitPackageModel: aModel [

]

{ #category : 'visiting' }
PulsarModelVisitor >> visitPackageTagModel: aModel [

]

{ #category : 'visiting' }
PulsarModelVisitor >> visitProjectModel: aModel [

]
