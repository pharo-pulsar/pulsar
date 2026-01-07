Class {
	#name : 'PulsarClassOutlineInstanceSideView',
	#superclass : 'PulsarClassOutlineSideView',
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'private' }
PulsarClassOutlineInstanceSideView >> collectProtocols [

	^ self model collectProtocols
]

{ #category : 'private' }
PulsarClassOutlineInstanceSideView >> collectVariables [

	^ self model collectVariables
]

{ #category : 'private' }
PulsarClassOutlineInstanceSideView >> methodsForProtocol: aProtocolModel [

	aProtocolModel ifNil: [ ^ #() ].
	^ self model collectMethodsForProtocol: aProtocolModel
]

{ #category : 'private' }
PulsarClassOutlineInstanceSideView >> newMethodModelForNewMethod [

	^ PvMethodModel
		newEnvironment: self model environmentModel 
		beNewMethodWithParent: self model
]

{ #category : 'visiting' }
PulsarClassOutlineInstanceSideView >> visitMethodModel: aModel [

	aModel isInstanceSide ifFalse: [ ^ self ].
	^ super visitMethodModel: aModel
]
