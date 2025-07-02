Class {
	#name : 'PvMethodHierarchyPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'treePresenter'
	],
	#category : 'Perspective-Method-View',
	#package : 'Perspective-Method',
	#tag : 'View'
}

{ #category : 'layout' }
PvMethodHierarchyPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: treePresenter;
		yourself
]

{ #category : 'transmission' }
PvMethodHierarchyPresenter >> defaultOutputPort [

	^ self outputActivationPort
]

{ #category : 'initialization' }
PvMethodHierarchyPresenter >> initializePresenters [

	treePresenter := self newEasyTreeListView.
	treePresenter
		addStyle: 'stTree';
		display: [ :aModel | aModel fullName ];
		displayIcon: [ :aModel | aModel iconComposite buildOn: self application ];
		children: [ :aModel | aModel ifNotNil: [ aModel children ] ].

	self addStyle: 'pvNavigation'.
	self addStyle: 'pvMethodHierarchyNavigation'
]

{ #category : 'initialization' }
PvMethodHierarchyPresenter >> itemToSelect [

	^ self model
]

{ #category : 'transmission' }
PvMethodHierarchyPresenter >> outputActivationPort [

	^ (SpActivationPort newPresenter: self)
		delegateTo: [ treePresenter ];
		yourself
]

{ #category : 'initialization' }
PvMethodHierarchyPresenter >> updatePresenter [

	treePresenter 
		roots: { self model hierarchyTopModel };
		selectItem: self itemToSelect.
		
	"Exclude huge hierarchies from the expandAll to avoid huge and unnecesary 
	 hierarchy (with a long, long time to be prepared)"
	self model isLargeHierarchy
		ifFalse: [ treePresenter expandAll ]
]
