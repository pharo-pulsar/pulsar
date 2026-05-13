Class {
	#name : 'PulsarToolbarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'actionToolbarPresenter',
		'presenterContainer'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'api' }
PulsarToolbarPresenter >> actions: anActionGroup [

	actionToolbarPresenter fillWith: anActionGroup
]

{ #category : 'layout' }
PulsarToolbarPresenter >> actionsFirstLayout [

	^ SpBoxLayout newHorizontal
		vAlignCenter;
		add: (SpBoxLayout newHorizontal
				hAlignStart;
				vAlignCenter;
				add: actionToolbarPresenter;
				yourself)
			expand: false;
		add: (presenterContainer := SpBoxLayout newHorizontal
			hAlignEnd;
			yourself);
		yourself
]

{ #category : 'layout' }
PulsarToolbarPresenter >> actionsLastLayout [

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
PulsarToolbarPresenter >> addPresenter: aPresenter [

	presenterContainer add: aPresenter
]

{ #category : 'api' }
PulsarToolbarPresenter >> addPresenterAtEnd: aPresenter [
	"used to add control boxes and that..."
	
	self layout 
		add: aPresenter
		expand: false
]

{ #category : 'api' }
PulsarToolbarPresenter >> addPresenterCloseButton: aString action: aBlock [

	^ self addPresenter: (self newButton 
		addStyle: 'flat';
		icon: (self iconNamed: 'close');
		help: aString;
		action: aBlock;
		yourself)
]

{ #category : 'api' }
PulsarToolbarPresenter >> addPresenterCloseButtonWithAction: aBlock [

	^ self addPresenter: (self newButton 
		addStyle: 'flat';
		icon: (self iconNamed: 'close');
		action: aBlock;
		yourself)
]

{ #category : 'api' }
PulsarToolbarPresenter >> addPresenterMenuButtonWith: anActionGroup [

	^ self addPresenter: (self newMenuButton 
		addStyle: 'flat';
		icon: (self iconNamed: 'menu');
		actions: anActionGroup;
		yourself)
]

{ #category : 'layout' }
PulsarToolbarPresenter >> defaultLayout [

	^ self actionsFirstLayout
]

{ #category : 'initialization' }
PulsarToolbarPresenter >> initialize [

	super initialize.
	self useActionsFirstLayout

]

{ #category : 'initialization' }
PulsarToolbarPresenter >> initializePresenters [

	self addStyle: 'pulsarToolbarPanel'.

	actionToolbarPresenter := self newToolbar
		addStyle: 'stToolbar';
		addStyle: 'pulsarToolbar';
		displayMode: self application toolbarDisplayMode;
		yourself	
]

{ #category : 'layout' }
PulsarToolbarPresenter >> useActionsFirstLayout [

	self layout: self actionsFirstLayout
]

{ #category : 'layout' }
PulsarToolbarPresenter >> useActionsLastLayout [

	self layout: self actionsLastLayout
]
