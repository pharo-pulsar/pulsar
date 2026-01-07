"
This view present the list of the traits a class/trait can be composed by.

"
Class {
	#name : 'PulsarClassOutlineTraitSideView',
	#superclass : 'PulsarClassOutlineSideView',
	#instVars : [
		'traitsListPresenter',
		'traitInstanceSidePresenter',
		'traitClassSidePresenter'
	],
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'layout' }
PulsarClassOutlineTraitSideView >> defaultLayout [

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
PulsarClassOutlineTraitSideView >> initializePresenters [

	super initializePresenters.
	
	traitsListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'dockTraitsList';
		display: #name;
		yourself.
		
	"traitInstanceSidePresenter := self instantiate: PulsarClassOutlineTraitInstanceSideView.
	traitClassSidePresenter := self instantiate: PulsarClassOutlineTraitClassSideView"
]
