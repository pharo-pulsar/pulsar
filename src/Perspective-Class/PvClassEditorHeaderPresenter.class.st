Class {
	#name : #PvClassEditorHeaderPresenter,
	#superclass : #PvEditorHeaderPresenter,
	#category : #'Perspective-Class-View'
}

{ #category : #'as yet unclassified' }
PvClassEditorHeaderPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	pathPresenter 
		removeAllSegments;
		addSegment: self model packageName;
		addSegment: self model name
]
