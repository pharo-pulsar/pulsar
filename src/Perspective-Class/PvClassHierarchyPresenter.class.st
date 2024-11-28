Class {
	#name : 'PvClassHierarchyPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'treePresenter'
	],
	#category : 'Perspective-Class-View',
	#package : 'Perspective-Class',
	#tag : 'View'
}

{ #category : 'api - focus' }
PvClassHierarchyPresenter >> defaultKeyboardFocus [

	^ treePresenter
]

{ #category : 'layout' }
PvClassHierarchyPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: treePresenter;
		yourself
]

{ #category : 'transmission' }
PvClassHierarchyPresenter >> defaultOutputPort [

	^ self outputActivationPort
]

{ #category : 'initialization' }
PvClassHierarchyPresenter >> initializePresenters [

	treePresenter := self newTree.
	treePresenter
		display: [ :aModel | aModel fullName ];
		displayIcon: [ :aModel | aModel iconComposite buildOn: self application ];
		children: [ :aModel | aModel children ].
		
	self addStyle: 'pvNavigation'.
	self addStyle: 'pvClassHierarchyNavigation'.
]

{ #category : 'transmission' }
PvClassHierarchyPresenter >> outputActivationPort [

	^ (SpActivationPort newPresenter: self)
		delegateTo: [ treePresenter ];
		yourself
]

{ #category : 'initialization' }
PvClassHierarchyPresenter >> updatePresenter [

	treePresenter roots: { self model hierarchyTopModel }.

	"Exclude huge hierarchies from the expandAll to avoid huge and unnecesary 
	 hierarchy (with a long, long time to be prepared)"
	self model isLargeHierarchy
		ifFalse: [ treePresenter expandAll ].
	
	treePresenter selectItem: self model
]
