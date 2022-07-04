Class {
	#name : #PvClassEditorView,
	#superclass : #PvEditorView,
	#instVars : [
		'textPresenter',
		'templatePresenter'
	],
	#category : #'Perspective-Class-View'
}

{ #category : #accessing }
PvClassEditorView >> content: aString [

	templatePresenter text: aString
]

{ #category : #initialization }
PvClassEditorView >> initializePresenters [

	self layout: (SpBoxLayout newVertical
		add: (templatePresenter := self newCode);
		yourself)
]

{ #category : #actions }
PvClassEditorView >> reset [

	templatePresenter triggerResetAction
]

{ #category : #actions }
PvClassEditorView >> submit [

	templatePresenter triggerSubmitAction
]

{ #category : #accessing }
PvClassEditorView >> tabPriority [

	^ 90
]

{ #category : #initialization }
PvClassEditorView >> title [

	^ self model ifNotNil: [ :aModel | aModel windowTitle ]
	
]

{ #category : #initialization }
PvClassEditorView >> updatePresenter [
	
	templatePresenter text: self model classDefinitionString 
]
