Class {
	#name : 'DockPlaygroundSnapshot',
	#superclass : 'DockPanelSnapshot',
	#instVars : [
		'cursorPositionIndex'
	],
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

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
	aPresenter codePresenter cursorPositionIndex: cursorPositionIndex
]

{ #category : 'initialization' }
DockPlaygroundSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	cursorPositionIndex := aPresenter codePresenter cursorPositionIndex
]
