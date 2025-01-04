Class {
	#name : 'DockClassOutlineInstanceSideView',
	#superclass : 'DockClassOutlineSideView',
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'private' }
DockClassOutlineInstanceSideView >> collectProtocols [

	^ self model collectProtocols
]

{ #category : 'private' }
DockClassOutlineInstanceSideView >> collectVariables [

	^ self model collectVariables
]

{ #category : 'private' }
DockClassOutlineInstanceSideView >> methodsForProtocol: aProtocolModel [

	aProtocolModel ifNil: [ ^ #() ].
	^ self model collectMethodsForProtocol: aProtocolModel
]

{ #category : 'private' }
DockClassOutlineInstanceSideView >> newMethodModelForNewMethod [

	^ PvMethodModel
		newEnvironment: self model environmentModel 
		beNewMethodWithParent: self model
]

{ #category : 'visiting' }
DockClassOutlineInstanceSideView >> visitMethodModel: aModel [

	aModel isInstanceSide ifFalse: [ ^ self ].
	^ super visitMethodModel: aModel
]
