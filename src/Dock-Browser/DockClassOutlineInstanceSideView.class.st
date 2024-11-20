Class {
	#name : 'DockClassOutlineInstanceSideView',
	#superclass : 'DockClassOutlineSideView',
	#category : 'Dock-Browser-ClassOutline',
	#package : 'Dock-Browser',
	#tag : 'ClassOutline'
}

{ #category : 'initialization' }
DockClassOutlineInstanceSideView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	variablesListPresenter items: self model collectVariables.
	listPresenter items: self model collectMethods
]

{ #category : 'visiting' }
DockClassOutlineInstanceSideView >> visitMethodModel: aModel [

	aModel isInstanceSide ifFalse: [ ^ self ].
	^ super visitMethodModel: aModel
]
