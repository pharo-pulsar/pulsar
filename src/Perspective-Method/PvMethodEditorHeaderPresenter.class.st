Class {
	#name : 'PvMethodEditorHeaderPresenter',
	#superclass : 'PvEditorHeaderPresenter',
	#instVars : [
		'actions'
	],
	#category : 'Perspective-Method-View',
	#package : 'Perspective-Method',
	#tag : 'View'
}

{ #category : 'as yet unclassified' }
PvMethodEditorHeaderPresenter >> actions [

	^ actions
]

{ #category : 'as yet unclassified' }
PvMethodEditorHeaderPresenter >> actions: anActionGroup [

	actions := anActionGroup.
	self updatePresenter
]

{ #category : 'as yet unclassified' }
PvMethodEditorHeaderPresenter >> activateModelClass [
		
	self withPerspectiveDo: [ :aPerspective | 
		aPerspective activateClass: self model methodClass ]
]

{ #category : 'as yet unclassified' }
PvMethodEditorHeaderPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	actionsLayout 
		removeAll;
		add: (self newToolbar
			beIcons;
			in: [ :this | 
				self actions ifNotNil: [
					this fillWith: self actions ] ];
			yourself).	
	
	pathPresenter 
		removeAllSegments;
		addSegment: (self newLink 
			label: self model methodClass name;
			action: [ self activateModelClass ]);
		addSegment: self model name
]
