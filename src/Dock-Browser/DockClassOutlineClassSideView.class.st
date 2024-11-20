Class {
	#name : 'DockClassOutlineClassSideView',
	#superclass : 'DockClassOutlineSideView',
	#instVars : [
		'sharedVariablesPresenter'
	],
	#category : 'Dock-Browser-ClassOutline',
	#package : 'Dock-Browser',
	#tag : 'ClassOutline'
}

{ #category : 'layout' }
DockClassOutlineClassSideView >> defaultLayout [

	^ SpPanedLayout newVertical
		positionOfSlider: 200;
		add: (SpPanedLayout newVertical 
			add: variablesListPresenter;
			add: sharedVariablesPresenter;
			yourself);
		add: listPresenter;
		yourself
]

{ #category : 'initialization' }
DockClassOutlineClassSideView >> initializePresenters [

	super initializePresenters.
	sharedVariablesPresenter := self newEasyListView
		addStyle: 'stList';
		display: #name;
		yourself
]

{ #category : 'initialization' }
DockClassOutlineClassSideView >> updatePresenter [

	self model ifNil: [ ^ self ].

	variablesListPresenter items: self model collectClassVariables.
	sharedVariablesPresenter items: self model collectClassSharedVariables.
	listPresenter items: self model collectClassMethods
]

{ #category : 'visiting' }
DockClassOutlineClassSideView >> visitMethodModel: aModel [

	aModel isInstanceSide ifTrue: [ ^ self ].
	^ super visitMethodModel: aModel
]
