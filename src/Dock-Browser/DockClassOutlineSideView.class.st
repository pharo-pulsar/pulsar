Class {
	#name : 'DockClassOutlineSideView',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'listPresenter',
		'variablesListPresenter'
	],
	#category : 'Dock-Browser-ClassOutline',
	#package : 'Dock-Browser',
	#tag : 'ClassOutline'
}

{ #category : 'initialization' }
DockClassOutlineSideView >> connectPresenters [

	listPresenter outputActivationPort 
		transmitDo: [ :anEntity | self owner triggerActivateEntity: anEntity ]
]

{ #category : 'layout' }
DockClassOutlineSideView >> defaultLayout [

	^ SpPanedLayout newVertical
		positionOfSlider: 200;
		add: variablesListPresenter;
		add: listPresenter;
		yourself
]

{ #category : 'initialization' }
DockClassOutlineSideView >> initializePresenters [

	variablesListPresenter := self newEasyListView
		addStyle: 'stList';
		display: #name;
		yourself.
		
	listPresenter := self newEasyListView 
		addStyle: 'stList';
		display: #name;
		yourself.	
]

{ #category : 'visiting' }
DockClassOutlineSideView >> visitMethodModel: aModel [

	listPresenter 
		selectItem: aModel
		scrollToSelection: true
]
