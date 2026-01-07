Class {
	#name : 'PulsarProjectRemoveModel',
	#superclass : 'PulsarModelVisitor',
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'visiting' }
PulsarProjectRemoveModel >> visitClassModel: aModel [

	self owner doRemoveClass
]

{ #category : 'visiting' }
PulsarProjectRemoveModel >> visitProjectModel: aModel [

	self owner removeProjectModel: aModel
]
