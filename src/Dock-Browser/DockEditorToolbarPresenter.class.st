Class {
	#name : 'DockEditorToolbarPresenter',
	#superclass : 'DockToolbarPresenter',
	#instVars : [
		'titlePresenter',
		'contentActionPresenter'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'layout' }
DockEditorToolbarPresenter >> actionsFirstLayout [

	^ SpBoxLayout newHorizontal
		add: actionToolbarPresenter expand: false;
		add: titlePresenter;
		add: (presenterContainer := SpBoxLayout newHorizontal
			hAlignEnd;
			yourself);
		add: contentActionPresenter expand: false;
		yourself
]

{ #category : 'layout' }
DockEditorToolbarPresenter >> actionsLastLayout [

	^ SpBoxLayout newHorizontal
		add: contentActionPresenter expand: false;
		add: (presenterContainer := SpBoxLayout newHorizontal
			hAlignStart;
			yourself);
		add: titlePresenter;
		add: actionToolbarPresenter expand: false;
		yourself
]

{ #category : 'private' }
DockEditorToolbarPresenter >> breadcrumbs [
	"used mainly for test"

	^ titlePresenter
]

{ #category : 'accessing' }
DockEditorToolbarPresenter >> contentActions: anActionGroup [

	contentActionPresenter fillWith: anActionGroup
]

{ #category : 'initialization' }
DockEditorToolbarPresenter >> initializePresenters [

	super initializePresenters.
	
	titlePresenter := self instantiate: DockBreadcrumbPresenter.
	contentActionPresenter := self newToolbar
		addStyle: 'stToolbar';
		addStyle: 'dockToolbar';
		displayMode: self application toolbarDisplayMode;
		yourself	
]

{ #category : 'accessing' }
DockEditorToolbarPresenter >> updateBreadcrumbWith: aBlock [

	titlePresenter updateBreadcrumbWith: aBlock
]
