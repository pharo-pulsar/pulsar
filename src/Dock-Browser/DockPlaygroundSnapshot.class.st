Class {
	#name : 'DockPlaygroundSnapshot',
	#superclass : 'DockPanelSnapshot',
	#instVars : [
		'cursorPositionIndex',
		'model'
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
	aPresenter codePresenter cursorPositionIndex: cursorPositionIndex
]

{ #category : 'initialization' }
DockPlaygroundSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	model := aPresenter model.
	cursorPositionIndex := aPresenter codePresenter cursorPositionIndex
]
