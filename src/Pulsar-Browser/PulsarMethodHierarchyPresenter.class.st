Class {
	#name : 'PulsarMethodHierarchyPresenter',
	#superclass : 'PulsarHierarchyPresenter',
	#instVars : [
		'editorPresenter'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
PulsarMethodHierarchyPresenter >> connectPresenters [

	super connectPresenters.
	treePresenter transmitTo: editorPresenter
]

{ #category : 'layout' }
PulsarMethodHierarchyPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: headerPresenter expand: false;
		add: (SpPanedLayout newVertical 
			add: treePresenter;
			add: editorPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
PulsarMethodHierarchyPresenter >> initializePresenters [

	super initializePresenters.
	
	self addStyle: 'pulsarMethodHierarchyFlyingBrowser'.
	
	editorPresenter := self instantiate: PulsarMethodEditor
]
