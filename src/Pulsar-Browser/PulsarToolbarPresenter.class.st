"
A toolbar bar for Pulsar tool headers. I host a Spec toolbar of actions and a horizontal container where other presenters can be placed, so a tool can show its commands next to its own controls in a single row.

My layout puts the action toolbar and the container side by side. By default the actions come first; `useActionsLastLayout` moves them to the end. Actions can be set from an `SpActionGroup`, and I offer helpers for common additions such as a flat close button or a menu button. Presenters added with `addPresenter:` go into the container, while `addPresenterAtEnd:` adds a presenter straight to my main layout, not to the container.

I am meant to be subclassed or composed inside a tool's presenter. My subclass `PulsarEditorToolbarPresenter` extends me with a breadcrumb title and a second toolbar for content-specific actions. Pulsar editors such as `PulsarEditor` use that subclass, as do several tool presenters like `PulsarMessageBrowser` and `PulsarPlayground`.

```smalltalk
toolbar := PulsarToolbarPresenter new.
toolbar actions: anActionGroup.
toolbar addPresenterCloseButtonWithAction: [ self close ].
toolbar useActionsLastLayout.
```
"
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
			vAlignCenter;
			yourself);
		yourself
]

{ #category : 'layout' }
PulsarToolbarPresenter >> actionsLastLayout [

	^ SpBoxLayout newHorizontal
		vAlignCenter;
		add: (presenterContainer := SpBoxLayout newHorizontal
			hAlignStart;
			vAlignCenter;
			yourself);
		add: (SpBoxLayout newHorizontal
				hAlignEnd;
				vAlignCenter;
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
