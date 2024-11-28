Class {
	#name : 'DockClassOutlineInstanceSideView',
	#superclass : 'DockClassOutlineSideView',
	#category : 'Dock-Browser-Outline',
	#package : 'Dock-Browser',
	#tag : 'Outline'
}

{ #category : 'private' }
DockClassOutlineInstanceSideView >> methodsFor: aProtocol [

	aProtocol ifNil: [ ^ #() ].
	^ self model collectMethodsForProtocol: aProtocol
]

{ #category : 'initialization' }
DockClassOutlineInstanceSideView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	variablesListPresenter items: self model collectVariables.
	protocolChooserPresenter items: self model collectProtocols.
	listPresenter items: self model collectMethods
]

{ #category : 'visiting' }
DockClassOutlineInstanceSideView >> visitMethodModel: aModel [

	aModel isInstanceSide ifFalse: [ ^ self ].
	^ super visitMethodModel: aModel
]
