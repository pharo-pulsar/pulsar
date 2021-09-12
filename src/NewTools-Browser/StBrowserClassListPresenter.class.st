Class {
	#name : #StBrowserClassListPresenter,
	#superclass : #StBrowserModelPresenter,
	#instVars : [
		'classTree'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #private }
StBrowserClassListPresenter >> buildTree: aCollectionOfClasses [
	
	aCollectionOfClasses ifNil: [ ^ #() ].
	^ StBrowserHierarchyBuilder buildFrom: aCollectionOfClasses
]

{ #category : #transmission }
StBrowserClassListPresenter >> defaultOutputPort [

	^ self outputClassSelectionPort
]

{ #category : #initialization }
StBrowserClassListPresenter >> initializePresenters [

	self layout: (SpBoxLayout newVertical
		add: (classTree := self newTree);
		yourself).
		
	classTree
		display: [ :aClassModel | aClassModel name ];
		displayIcon: [ :aClassModel | aClassModel icon ];
		children: [ :aNode | aNode children sorted: #name ascending ]
]

{ #category : #transmission }
StBrowserClassListPresenter >> inputClassesPort [

	^ classTree inputRootsPort
]

{ #category : #transmission }
StBrowserClassListPresenter >> outputClassSelectionPort [

	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ classTree ];
		transform: [ :aNode | aNode ifNotNil: #element ];
		yourself
]

{ #category : #initialization }
StBrowserClassListPresenter >> updatePresenter [

	classTree 
		roots: ((self buildTree: self model) sorted: #name ascending);
		expandAll.
]

{ #category : #events }
StBrowserClassListPresenter >> whenClassSelectionChangedDo: aBlock [

	classTree whenSelectionChangedDo: aBlock
]
