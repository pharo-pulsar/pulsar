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
		add: actionToolbarPresenter expand: false;
		add: titlePresenter;
		add: (presenterContainer := SpBoxLayout newHorizontal
			hAlignEnd;
			yourself);
		add: contentActionPresenter expand: false;
		yourself
]

{ #category : 'layout' }
PulsarEditorToolbarPresenter >> actionsLastLayout [

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

	self updateBreadcrumbWith: [ :aBreadcrumb | aBreadcrumb addSegment: aString ]
]

{ #category : 'accessing' }
PulsarEditorToolbarPresenter >> updateBreadcrumbWith: aBlock [

	titlePresenter updateBreadcrumbWith: aBlock
]
