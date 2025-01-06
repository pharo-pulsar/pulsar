Class {
	#name : 'DockEditorToolbarPresenter',
	#superclass : 'DockToolbarPresenter',
	#instVars : [
		'titlePresenter'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'layout' }
DockEditorToolbarPresenter >> actionsFirstLayout [

	^ SpBoxLayout newHorizontal
		add: (SpBoxLayout newHorizontal
				hAlignStart;
				add: actionToolbarPresenter;
				yourself)
			expand: false;
		add: titlePresenter;
		add: (presenterContainer := SpBoxLayout newHorizontal
			hAlignEnd;
			yourself);
		yourself
]

{ #category : 'layout' }
DockEditorToolbarPresenter >> actionsLastLayout [

	^ SpBoxLayout newHorizontal
		add: (presenterContainer := SpBoxLayout newHorizontal
			hAlignStart;
			yourself);
		add: titlePresenter;
		add: (SpBoxLayout newHorizontal
				hAlignEnd;
				add: actionToolbarPresenter;
				yourself)
			expand: false;
		yourself
]

{ #category : 'initialization' }
DockEditorToolbarPresenter >> initializePresenters [

	super initializePresenters.
	
	titlePresenter := self instantiate: DockBreadcrumbPresenter
]

{ #category : 'accessing' }
DockEditorToolbarPresenter >> updateBreadcrumbWith: aBlock [

	titlePresenter updateBreadcrumbWith: aBlock
]
