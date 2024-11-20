Class {
	#name : 'DockMethodEditor',
	#superclass : 'DockEditor',
	#category : 'Dock-Browser-Core',
	#package : 'Dock-Browser',
	#tag : 'Core'
}

{ #category : 'initialization' }
DockMethodEditor >> initializePresenters [

	super initializePresenters.
	self addStyle: 'dockMethodEditor'
]

{ #category : 'initialization' }
DockMethodEditor >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self updatingWhile: [  
		editorPresenter 
			beForMethod: self model entity;
			text: self model sourceCode ].
	
	"update window title if needed"
	self withDockableWindowDo: [ :w | w title: self model name ]
]
