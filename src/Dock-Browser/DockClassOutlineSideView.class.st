Class {
	#name : 'DockClassOutlineSideView',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'listPresenter',
		'variablesListPresenter',
		'selectorToolbarPresenter',
		'protocolChooserPresenter'
	],
	#category : 'Dock-Browser-Outline',
	#package : 'Dock-Browser',
	#tag : 'Outline'
}

{ #category : 'initialization' }
DockClassOutlineSideView >> connectPresenters [

	protocolChooserPresenter 
		transmitTo: listPresenter transform: [ :aSelection | self methodsFor: aSelection selectedItem ].
	listPresenter outputActivationPort 
		transmitDo: [ :anEntity | self owner triggerActivateEntity: anEntity ]
]

{ #category : 'layout' }
DockClassOutlineSideView >> defaultLayout [

	^ SpPanedLayout newVertical
		positionOfSlider: 200;
		add: variablesListPresenter;
		add: (SpBoxLayout newVertical 
			add: (SpBoxLayout newHorizontal
					add: protocolChooserPresenter;
					yourself) 
				expand: false;
			add: listPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
DockClassOutlineSideView >> initializePresenters [

	variablesListPresenter := self newEasyListView
		addStyle: 'stList';
		display: #name;
		yourself.
		
	selectorToolbarPresenter := self newPresenter
		layout: SpBoxLayout newHorizontal;
		yourself.
		
	protocolChooserPresenter := self newDropDown
		addStyle: 'stDropList';
		display: #name;
		yourself.
		
	listPresenter := self newEasyListView 
		addStyle: 'stList';
		display: #name;
		searchMatching: [ :aModel :aString | 
			aModel name asLowercase beginsWith: aString asLowercase ];
		yourself
]

{ #category : 'private' }
DockClassOutlineSideView >> methodsFor: aProtocol [

	self subclassResponsibility
]

{ #category : 'visiting' }
DockClassOutlineSideView >> visitClassModel: aModel [

	listPresenter unselectAll.
	variablesListPresenter unselectAll
]

{ #category : 'visiting' }
DockClassOutlineSideView >> visitMethodModel: aModel [

	listPresenter 
		selectItem: aModel
		scrollToSelection: true
]
