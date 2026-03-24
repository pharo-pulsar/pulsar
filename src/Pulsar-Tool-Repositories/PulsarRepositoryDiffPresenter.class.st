"
A view to display the difference between a commit/stage/change tree and another. 
This can be between the image and the curretn git working copy, or between two commits, whatever is needed to show.

The model is required to understand `diffNode` (which contains the root of the diff to be shown, an instance of `PulsarDiffNode`.
"
Class {
	#name : 'PulsarRepositoryDiffPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'diffTreePresenter',
		'diffPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View'
}

{ #category : 'initialization' }
PulsarRepositoryDiffPresenter >> connectPresenters [

	diffTreePresenter transmitTo: diffPresenter
]

{ #category : 'layout' }
PulsarRepositoryDiffPresenter >> defaultLayout [

	^ SpPanedLayout newHorizontal
		positionOfSlider: 280;
		add: diffTreePresenter;
		add: (SpScrollableLayout with: diffPresenter);
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryDiffPresenter >> initializePresenters [

	diffTreePresenter := self newEasyTreeListView
		addStyle: 'stTree';
		addStyle: 'pulsarRepositoryChangesTree';
		rowPresenterClass: PulsarRepositoryReadOnlyChangeRow;
		display: [ :aNode | aNode description ];
		children: [ :aNode | aNode children ];
		"actions: (self actions actionsFor: #nodeActions);"
		yourself.
	diffPresenter := self instantiate: PulsarRepositoryDiffEditor
]

{ #category : 'initialization' }
PulsarRepositoryDiffPresenter >> patchPresenterClass [

	^ PulsarRepositorySideBySidePresenter
]

{ #category : 'initialization' }
PulsarRepositoryDiffPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	diffTreePresenter 
		roots: self model diffNode children;
		expandAll;
		selectPath: #(1)
]
