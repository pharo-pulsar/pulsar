Class {
	#name : #PvEditorHeaderPresenter,
	#superclass : #SpPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'actionsLayout',
		'pathPresenter',
		'menuButtonPresenter',
		'menuCommandGroup'
	],
	#category : #'Perspective-View-Editor'
}

{ #category : #accessing }
PvEditorHeaderPresenter >> addSegment: aString action: aBlock [

	pathPresenter 
		addSegment: aString 
		action: aBlock
]

{ #category : #layout }
PvEditorHeaderPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight 
		vAlignCenter;
		borderWidth: 3;
		spacing: 3;
		add: (actionsLayout := SpBoxLayout newLeftToRight) expand: false; 
		add: pathPresenter;
		addLast: menuButtonPresenter expand: false;
		yourself
]

{ #category : #initialization }
PvEditorHeaderPresenter >> initializePresenters [

	pathPresenter := self instantiate: PvEditorPathPresenter.
	menuButtonPresenter := self newMenuButton
		addStyle: 'small';
		addStyle: 'flat';
		icon: ((PvCompositeIcon newName: 'view-more-symbolic') buildOn: self application);
		menu: [ self menu ];
		yourself
]

{ #category : #private }
PvEditorHeaderPresenter >> menu [

	^ self menuCommandGroup 
		ifNotNil: [ self menuCommandGroup asMenuPresenter ]
]

{ #category : #accessing }
PvEditorHeaderPresenter >> menuCommandGroup [

	^ menuCommandGroup
]

{ #category : #accessing }
PvEditorHeaderPresenter >> menuCommandGroup: aCommandGroup [

	menuCommandGroup := aCommandGroup
]
