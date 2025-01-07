Class {
	#name : 'DockClassOutlineTraitSideView',
	#superclass : 'DockClassOutlineSideView',
	#instVars : [
		'traitsListPresenter'
	],
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'layout' }
DockClassOutlineTraitSideView >> defaultLayout [

	^ SpPanedLayout newVertical
		positionOfSlider: 360;
		add: (SpPanedLayout newVertical 
			positionOfSlider: 180;
			add: (SpPanedLayout newVertical 
				add: traitsListPresenter;
				add: variablesListPresenter;
				yourself);			
			yourself);
		add: (SpBoxLayout newVertical
			add: listToolbarPresenter expand: false; 
			add: listPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
DockClassOutlineTraitSideView >> initializePresenters [

	super initializePresenters.
	traitsListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'dockTraitsList';
		display: #name;
		yourself
]
