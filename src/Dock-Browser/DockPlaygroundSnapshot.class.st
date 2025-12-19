Class {
	#name : 'DockPlaygroundSnapshot',
	#superclass : 'DockPanelSnapshot',
	#instVars : [
		'cursorPositionIndex',
		'bindings',
		'content'
	],
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'accessing' }
DockPlaygroundSnapshot >> bindings [

	^ bindings
]

{ #category : 'accessing' }
DockPlaygroundSnapshot >> cursorPositionIndex [

	^ cursorPositionIndex
]

{ #category : 'accessing' }
DockPlaygroundSnapshot >> model [

	^ model
]

{ #category : 'initialization' }
DockPlaygroundSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	"For some reason I need to re-set the model here (even if it is passed on initialization)"
	aPresenter model: self model.
	aPresenter codePresenter 
		text: content;
		cursorPositionIndex: cursorPositionIndex.
	aPresenter codePresenter interactionModel bindings: bindings.
	
	aPresenter postRestoreSnapshot: self
]

{ #category : 'initialization' }
DockPlaygroundSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	content := aPresenter codePresenter text.
	cursorPositionIndex := aPresenter codePresenter cursorPositionIndex.
	bindings := aPresenter codePresenter interactionModel lastingBindings
]
