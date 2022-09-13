Class {
	#name : #PvClassEditorHeaderPresenter,
	#superclass : #PvEditorHeaderPresenter,
	#instVars : [
		'actionsCommandGroup'
	],
	#category : #'Perspective-Class-View'
}

{ #category : #'as yet unclassified' }
PvClassEditorHeaderPresenter >> actionsCommandGroup [
		
	^ actionsCommandGroup ifNil: [ actionsCommandGroup := self newActionsCommandGroup ]
]

{ #category : #'as yet unclassified' }
PvClassEditorHeaderPresenter >> newActionsCommandGroup [

	^ (CmCommandGroup forSpecNamed: 'Actions')
		register: (PvClassHierarchyNavigationCommand forSpecContext: self);
		yourself
]

{ #category : #'as yet unclassified' }
PvClassEditorHeaderPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	actionsLayout 
		removeAll;
		add: (self newToolbar
			beIcons;
			fillWith: self actionsCommandGroup;
			yourself);
		yourself.
	
	pathPresenter 
		removeAllSegments;
		addSegment: self model packageName;
		addSegment: self model name
]
