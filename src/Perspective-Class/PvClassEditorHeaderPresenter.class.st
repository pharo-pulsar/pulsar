Class {
	#name : 'PvClassEditorHeaderPresenter',
	#superclass : 'PvEditorHeaderPresenter',
	#instVars : [
		'actions'
	],
	#category : 'Perspective-Class-View',
	#package : 'Perspective-Class',
	#tag : 'View'
}

{ #category : 'accessing' }
PvClassEditorHeaderPresenter >> actions [

	^ actions
]

{ #category : 'accessing' }
PvClassEditorHeaderPresenter >> actions: anObject [

	actions := anObject.
	self updatePresenter
]

{ #category : 'initialization' }
PvClassEditorHeaderPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	actionsLayout 
		removeAll;
		add: (self newToolbar
			beIcons;
			in: [ :this | 
				self actions ifNotNil: [ 
					this fillWith: self actions ] ];
			yourself);
		yourself.
	
	pathPresenter 
		removeAllSegments;
		addSegment: self model packageName;
		addSegment: self model name
]
