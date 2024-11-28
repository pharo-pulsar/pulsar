Class {
	#name : 'DockClassOutlineClassSideView',
	#superclass : 'DockClassOutlineSideView',
	#instVars : [
		'sharedVariablesPresenter'
	],
	#category : 'Dock-Browser-Outline',
	#package : 'Dock-Browser',
	#tag : 'Outline'
}

{ #category : 'layout' }
DockClassOutlineClassSideView >> defaultLayout [

	^ SpPanedLayout newVertical
		positionOfSlider: 200;
		add: (SpPanedLayout newVertical 
			add: variablesListPresenter;
			add: sharedVariablesPresenter;
			yourself);
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
DockClassOutlineClassSideView >> initializePresenters [

	super initializePresenters.
	sharedVariablesPresenter := self newEasyListView
		addStyle: 'stList';
		display: #name;
		yourself
]

{ #category : 'private' }
DockClassOutlineClassSideView >> methodsFor: aProtocol [

	aProtocol ifNil: [ ^ #() ].
	^ self model collectClassMethodsForProtocol: aProtocol
]

{ #category : 'initialization' }
DockClassOutlineClassSideView >> updatePresenter [

	self model ifNil: [ ^ self ].

	variablesListPresenter items: self model collectClassVariables.
	sharedVariablesPresenter items: self model collectClassSharedVariables.
	protocolChooserPresenter items: self model collectClassProtocols.
	listPresenter items: self model collectClassMethods
]

{ #category : 'visiting' }
DockClassOutlineClassSideView >> visitClassModel: aModel [
	
	super visitClassModel: aModel.
	sharedVariablesPresenter unselectAll
]

{ #category : 'visiting' }
DockClassOutlineClassSideView >> visitMethodModel: aModel [

	aModel isInstanceSide ifTrue: [ ^ self ].
	^ super visitMethodModel: aModel
]
