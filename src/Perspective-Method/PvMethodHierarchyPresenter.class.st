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
		displayIcon: [ :aModel | self iconNamed: aModel iconName ];
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
	self flag: #TODO. "hierarchyTopModel can be nil if we are in a trait, and traits have no hierarchy. 
	we may consider change the hierarchy button on the class editor if showing a trait?"
	treePresenter 
		roots: (self model hierarchyTopModel
			ifNotNil: [ :aTopModel | { aTopModel } ]
			ifNil: [ #() ]);
		selectItem: self itemToSelect.
		
	"Exclude huge hierarchies from the expandAll to avoid huge and unnecesary 
	 hierarchy (with a long, long time to be prepared)"
	self model isLargeHierarchy
		ifFalse: [ treePresenter expandAll ]
]
