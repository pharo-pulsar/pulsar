Class {
	#name : 'DockToolbarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'actionToolbarPresenter',
		'presenterContainer'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'api' }
DockToolbarPresenter >> actions: anActionGroup [

	actionToolbarPresenter fillWith: anActionGroup
]

{ #category : 'layout' }
DockToolbarPresenter >> actionsFirstLayout [

	^ SpBoxLayout newHorizontal
		add: (SpBoxLayout newHorizontal
				hAlignStart;
				add: actionToolbarPresenter;
				yourself)
			expand: false;
		add: (presenterContainer := SpBoxLayout newHorizontal
			hAlignEnd;
			yourself);
		yourself
]

{ #category : 'layout' }
DockToolbarPresenter >> actionsLastLayout [

	^ SpBoxLayout newHorizontal
		add: (presenterContainer := SpBoxLayout newHorizontal
			hAlignStart;
			yourself);
		add: (SpBoxLayout newHorizontal
				hAlignEnd;
				add: actionToolbarPresenter;
				yourself)
			expand: false;
		yourself
]

{ #category : 'api' }
DockToolbarPresenter >> addPresenter: aPresenter [

	presenterContainer add: aPresenter
]

{ #category : 'api' }
DockToolbarPresenter >> addPresenterCloseButton: aString action: aBlock [

	^ self addPresenter: (self newButton 
		addStyle: 'flat';
		icon: (self iconNamed: 'close');
		help: aString;
		action: aBlock;
		yourself)
]

{ #category : 'api' }
DockToolbarPresenter >> addPresenterCloseButtonWithAction: aBlock [

	^ self addPresenter: (self newButton 
		addStyle: 'flat';
		icon: (self iconNamed: 'close');
		action: aBlock;
		yourself)
]

{ #category : 'api' }
DockToolbarPresenter >> addPresenterMenuButtonWith: anActionGroup [

	^ self addPresenter: (self newMenuButton 
		addStyle: 'flat';
		icon: (self iconNamed: 'menu');
		actions: anActionGroup;
		yourself)
]

{ #category : 'layout' }
DockToolbarPresenter >> defaultLayout [

	^ self actionsFirstLayout
]

{ #category : 'initialization' }
DockToolbarPresenter >> initialize [

	super initialize.
	self useActionsFirstLayout

]

{ #category : 'initialization' }
DockToolbarPresenter >> initializePresenters [

	self addStyle: 'dockToolbarPanel'.

	actionToolbarPresenter := self newToolbar
		addStyle: 'stToolbar';
		addStyle: 'dockToolbar';
		displayMode: self application toolbarDisplayMode;
		yourself	
]

{ #category : 'layout' }
DockToolbarPresenter >> useActionsFirstLayout [

	self layout: self actionsFirstLayout
]

{ #category : 'layout' }
DockToolbarPresenter >> useActionsLastLayout [

	self layout: self actionsLastLayout
]
