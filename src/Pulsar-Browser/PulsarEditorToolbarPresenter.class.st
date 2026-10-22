"
PulsarEditorToolbarPresenter is the standard header bar for Pulsar editors and tool panels.

It combines three concerns in a single row: the commands that belong to the tool, a breadcrumb that describes what the tool is currently showing, and a second, content-specific action area. The breadcrumb is a `PulsarBreadcrumbPresenter`, so callers build a path from plain segments, links, or buttons instead of being limited to a fixed title. Both action areas are Spec toolbars filled from `SpActionGroup` instances. The main actions come from the inherited `PulsarToolbarPresenter`; the content actions are kept separate so they can be replaced without rebuilding the header. Extra presenters can also be inserted between these areas.

The layout keeps the main actions and the content actions on opposite ends, with the breadcrumb and any extra presenters between them. Switching between the actions-first and actions-last layouts produces the two mirrored arrangements without changing the header's contents. The presenter is purely a view container and holds no model of its own.

```smalltalk
header := PulsarEditorToolbarPresenter new.
header actions: self editorToolbarActions.
header contentActions: self contentActions.
header updateBreadcrumbWith: [ :breadcrumb |
    breadcrumb
        addLinkSegment: 'PulsarEditor' action: [ self browseClass ];
        addSegment: 'open' ].
```

Pulsar editors such as `PulsarEditor`, `PulsarMethodEditor`, and `PulsarWebEditor` use it as their breadcrumb and command bar, while tool presenters such as `PulsarMessageBrowser`, `PulsarPlayground`, and the inspector panels reuse it as a compact section header.
"
Class {
	#name : 'PulsarEditorToolbarPresenter',
	#superclass : 'PulsarToolbarPresenter',
	#instVars : [
		'titlePresenter',
		'contentActionPresenter'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'layout' }
PulsarEditorToolbarPresenter >> actionsFirstLayout [

	^ SpBoxLayout newHorizontal
		vAlignCenter;
		add: (SpBoxLayout newHorizontal
				vAlignCenter;
				add: actionToolbarPresenter;
				yourself) 
			expand: false;
		add: titlePresenter;
		add: (presenterContainer := SpBoxLayout newHorizontal
			hAlignEnd;
			vAlignCenter;
			yourself);
		add: contentActionPresenter expand: false;
		yourself
]

{ #category : 'layout' }
PulsarEditorToolbarPresenter >> actionsLastLayout [

	^ SpBoxLayout newHorizontal
		vAlignCenter;
		add: contentActionPresenter expand: false;
		add: (presenterContainer := SpBoxLayout newHorizontal
			hAlignStart;
			vAlignCenter;
			yourself);
		add: titlePresenter;
		add: (SpBoxLayout newHorizontal
				add: actionToolbarPresenter;
				vAlignCenter;
				yourself) 
			expand: false;
		yourself
]

{ #category : 'private' }
PulsarEditorToolbarPresenter >> breadcrumbs [
	"used mainly for test"

	^ titlePresenter
]

{ #category : 'accessing' }
PulsarEditorToolbarPresenter >> contentActions: anActionGroup [

	contentActionPresenter fillWith: anActionGroup
]

{ #category : 'initialization' }
PulsarEditorToolbarPresenter >> initializePresenters [

	super initializePresenters.
	
	titlePresenter := self instantiate: PulsarBreadcrumbPresenter.
	contentActionPresenter := self newToolbar
		addStyle: 'stToolbar';
		addStyle: 'pulsarToolbar';
		displayMode: self application toolbarDisplayMode;
		yourself
]

{ #category : 'accessing' }
PulsarEditorToolbarPresenter >> resetContentActions [

	contentActionPresenter fillWith: SpActionGroup new
]

{ #category : 'accessing' }
PulsarEditorToolbarPresenter >> title: aString [
	"a convenience method to set simple titles"

	self updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: (self newLabel 
			useMarkup;
			label: aString;
			yourself) ]
]

{ #category : 'accessing' }
PulsarEditorToolbarPresenter >> updateBreadcrumbWith: aBlock [

	titlePresenter updateBreadcrumbWith: aBlock
]
