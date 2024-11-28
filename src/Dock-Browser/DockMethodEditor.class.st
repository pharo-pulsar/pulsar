Class {
	#name : 'DockMethodEditor',
	#superclass : 'DockEditor',
	#category : 'Dock-Browser-Editor',
	#package : 'Dock-Browser',
	#tag : 'Editor'
}

{ #category : 'initialization' }
DockMethodEditor >> initializePresenters [

	super initializePresenters.
	self addStyle: 'dockMethodEditor'
]

{ #category : 'private' }
DockMethodEditor >> originalContent [

	^ self model sourceCode
]

{ #category : 'initialization' }
DockMethodEditor >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self updatingWhile: [  
		editorPresenter 
			beForMethod: self model entity;
			text: self model sourceCode ].
	
	"update window title if needed"
	self withPanelWindowDo: [ :w | w title: self model name ]
]
