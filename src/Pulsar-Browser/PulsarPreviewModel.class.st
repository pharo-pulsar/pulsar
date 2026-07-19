Class {
	#name : 'PulsarPreviewModel',
	#superclass : 'Object',
	#traits : 'PulsarTModelSnapshot',
	#classTraits : 'PulsarTModelSnapshot classTrait',
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing' }
PulsarPreviewModel >> fullName [

	^ self name
]

{ #category : 'accessing' }
PulsarPreviewModel >> iconName [

	^ 'preview'
]

{ #category : 'accessing' }
PulsarPreviewModel >> name [

	^ 'Preview'
]

{ #category : 'accessing' }
PulsarPreviewModel >> title [

	^ self name
]
