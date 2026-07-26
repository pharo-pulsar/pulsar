Class {
	#name : 'PulsarPreviewModel',
	#superclass : 'PvBaseModel',
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing' }
PulsarPreviewModel >> iconName [

	^ 'preview'
]

{ #category : 'accessing' }
PulsarPreviewModel >> name [

	^ self entity 
		ifNotNil: [ 'Preview: ', self entity name ]
		ifNil: [ 'Preview' ]
]

{ #category : 'accessing' }
PulsarPreviewModel >> updateEntityWith: anEntityModel [

	entity := anEntityModel
]
