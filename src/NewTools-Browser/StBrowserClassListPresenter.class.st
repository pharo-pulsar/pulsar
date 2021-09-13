Class {
	#name : #StBrowserClassListPresenter,
	#superclass : #StBrowserPanelPresenter,
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

{ #category : #private }
StBrowserClassListPresenter >> flatNodes: aCollection [ 
	
	^ aCollection flatCollect: [ :each | each withAllChildren ]
]

{ #category : #initialization }
StBrowserClassListPresenter >> initializePresenters [

	self layout: (SpBoxLayout newVertical
		add: (classTree := self newTree);
		yourself).
		
	classTree
		display: [ :aClassModel | aClassModel name ];
		displayIcon: [ :aClassModel | self iconNamed: aClassModel iconName ];
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

{ #category : #'accessing - selection' }
StBrowserClassListPresenter >> selectItem: aClassModel [
	| path |

	path := ((self flatNodes: classTree roots)
		detect: [ :each | each element = aClassModel ])
		withAllParents.

	classTree 
		selectPathByItems: path 
		scrollToSelection: true
]

{ #category : #'accessing - selection' }
StBrowserClassListPresenter >> selectedItem [
	
	^ classTree selectedItem element
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
