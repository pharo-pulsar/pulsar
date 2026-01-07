Class {
	#name : 'PulsarPlaygroundSnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#instVars : [
		'cursorPositionIndex',
		'bindings',
		'content'
	],
	#category : 'Pulsar-Browser-Tool-Playground',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'accessing' }
PulsarPlaygroundSnapshot >> bindings [

	^ bindings
]

{ #category : 'accessing' }
PulsarPlaygroundSnapshot >> cursorPositionIndex [

	^ cursorPositionIndex
]

{ #category : 'accessing' }
PulsarPlaygroundSnapshot >> model [

	^ model
]

{ #category : 'initialization' }
PulsarPlaygroundSnapshot >> restoreTo: aPresenter [

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
PulsarPlaygroundSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	content := aPresenter codePresenter text.
	cursorPositionIndex := aPresenter codePresenter cursorPositionIndex.
	bindings := aPresenter codePresenter interactionModel lastingBindings
]
