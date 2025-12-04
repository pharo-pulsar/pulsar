"
This view present the list of the traits a class/trait can be composed by.

"
Class {
	#name : 'DockClassOutlineTraitSideView',
	#superclass : 'DockClassOutlineSideView',
	#instVars : [
		'traitsListPresenter',
		'traitInstanceSidePresenter',
		'traitClassSidePresenter'
	],
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'layout' }
DockClassOutlineTraitSideView >> defaultLayout [

	^ SpPanedLayout newVertical
		positionOfSlider: 360;
		add: traitsListPresenter;
		"add: (SpTabLayout new 
			add: traitInstanceSidePresenter label: 'Instance';
			add: traitClassSidePresenter label: 'Class';
			yourself);"
		yourself
]

{ #category : 'initialization' }
DockClassOutlineTraitSideView >> initializePresenters [

	super initializePresenters.
	
	traitsListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'dockTraitsList';
		display: #name;
		yourself.
		
	"traitInstanceSidePresenter := self instantiate: DockClassOutlineTraitInstanceSideView.
	traitClassSidePresenter := self instantiate: DockClassOutlineTraitClassSideView"
]
