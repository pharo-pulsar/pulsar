Class {
	#name : #PvMethodEditorHeaderPresenter,
	#superclass : #PvEditorHeaderPresenter,
	#category : #'Perspective-Method-View'
}

{ #category : #'as yet unclassified' }
PvMethodEditorHeaderPresenter >> updatePresenter [
'OK' crTrace.
	self model ifNil: [ ^ self ].
	
	pathPresenter 
		removeAllSegments;
		addSegment: self model methodClass name;
		addSegment: self model name
]
