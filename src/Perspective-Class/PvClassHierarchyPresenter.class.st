Class {
	#name : #PvClassHierarchyPresenter,
	#superclass : #SpPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'treePresenter'
	],
	#category : #'Perspective-Class-View'
}

{ #category : #layout }
PvClassHierarchyPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: treePresenter;
		yourself
]

{ #category : #transmission }
PvClassHierarchyPresenter >> defaultOutputPort [

	^ self outputActivationPort
]

{ #category : #initialization }
PvClassHierarchyPresenter >> initializePresenters [

	treePresenter := self newTree.
	treePresenter
		display: [ :aModel | aModel name ];
		displayIcon: [ :aModel | aModel iconComposite buildOn: self application ];
		children: [ :aModel | aModel subclassesModels ].
		
	self addStyle: 'pvClassHierarchyNavigation'
]

{ #category : #transmission }
PvClassHierarchyPresenter >> outputActivationPort [

	^ (SpActivationPort newPresenter: self)
		delegateTo: [ treePresenter ];
		yourself
]

{ #category : #initialization }
PvClassHierarchyPresenter >> updatePresenter [

	treePresenter 
		roots: { self model hierarchyTopModel };
		selectItem: self model.
		
	"Exclude huge hierarchies from the expandAll to avoid huge and unnecesary 
	 hierarchy (with a long, long time to be prepared)"
	({ Object. ProtoObject } includes: self model entity)
		ifFalse: [ treePresenter expandAll ]
]
