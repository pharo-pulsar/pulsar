Class {
	#name : 'DockClassOutlineClassSideView',
	#superclass : 'DockClassOutlineSideView',
	#instVars : [
		'sharedVariablesToolbarPresenter',
		'sharedVariablesPresenter'
	],
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'private' }
DockClassOutlineClassSideView >> collectProtocols [

	^ self model collectClassProtocols
]

{ #category : 'private' }
DockClassOutlineClassSideView >> collectSharedVariables [

	^  self model collectClassSharedVariables
]

{ #category : 'private' }
DockClassOutlineClassSideView >> collectVariables [

	^ self model collectClassVariables
]

{ #category : 'layout' }
DockClassOutlineClassSideView >> defaultLayout [

	^ SpPanedLayout newVertical
		positionOfSlider: 360;
		add: (SpPanedLayout newVertical 
			positionOfSlider: 200;
			add: (SpPanedLayout newVertical 
				add: (SpBoxLayout newVertical
					add: variablesToolbarPresenter expand: false;
					add: variablesListPresenter;
					yourself);
				add: (SpBoxLayout newVertical
					add: sharedVariablesToolbarPresenter expand: false;
					add: sharedVariablesPresenter;
					yourself);
				yourself);
			add: (SpBoxLayout newVertical
				add: protocolToolbarPresenter expand: false;
				add: protocolListPresenter;
				yourself);
			yourself);
		add: (SpBoxLayout newVertical
			add: listToolbarPresenter expand: false;
			add: listPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
DockClassOutlineClassSideView >> initializePresenters [

	super initializePresenters.
	
	sharedVariablesToolbarPresenter := self instantiate: DockToolbarPresenter.
	sharedVariablesToolbarPresenter actions: self sharedVariablesToolbarActions.
	
	sharedVariablesPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'dockSharedVariablesList';
		display: #name;
		yourself
]

{ #category : 'private' }
DockClassOutlineClassSideView >> methodsForProtocol: aProtocolModel [

	aProtocolModel ifNil: [ ^ #() ].
	^ self model collectClassMethodsForProtocol: aProtocolModel
]

{ #category : 'private' }
DockClassOutlineClassSideView >> newMethodModelForNewMethod [

	^ PvMethodModel
		newEnvironment: self model environmentModel 
		beNewClassMethodWithParent: self model
]

{ #category : 'initialization' }
DockClassOutlineClassSideView >> sharedVariablesToolbarActions [

	^ SpActionGroup new
		addActionWith: [ :action | action 
			name: 'Add';
			description: 'Add a new shared variable';
			iconName: #add;
			action: [ self doAddSharedVariable ] ]	
]

{ #category : 'initialization' }
DockClassOutlineClassSideView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [
		self updatingWhile: [ 
			super updatePresenter.
			sharedVariablesPresenter items: self collectSharedVariables ] ]
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
