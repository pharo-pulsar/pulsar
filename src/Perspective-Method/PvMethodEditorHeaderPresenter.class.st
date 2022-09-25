Class {
	#name : #PvMethodEditorHeaderPresenter,
	#superclass : #PvEditorHeaderPresenter,
	#instVars : [
		'actionsCommandGroup'
	],
	#category : #'Perspective-Method-View'
}

{ #category : #'as yet unclassified' }
PvMethodEditorHeaderPresenter >> actionsCommandGroup [

	^ actionsCommandGroup ifNil: [ actionsCommandGroup := self newActionsCommandGroup ]
]

{ #category : #'as yet unclassified' }
PvMethodEditorHeaderPresenter >> activateModelClass [
		
	self withPerspectiveDo: [ :aPerspective | 
		aPerspective activateClass: self model methodClass ]
]

{ #category : #'as yet unclassified' }
PvMethodEditorHeaderPresenter >> newActionsCommandGroup [

	^ (PvCommandGroup forSpecNamed: 'Actions')
		register: (PvMethodHierarchyNavigationCommand forSpecContext: self);
		yourself
]

{ #category : #'as yet unclassified' }
PvMethodEditorHeaderPresenter >> updatePresenter [

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
		addSegment: (self newLink 
			label: self model methodClass name;
			action: [ self activateModelClass ]);
		addSegment: self model name
]
