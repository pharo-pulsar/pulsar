Class {
	#name : #PvOutlineView,
	#superclass : #PvContainedPresenter,
	#instVars : [
		'classTreePresenter',
		'outlineTreePresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Outline'
}

{ #category : #accessing }
PvOutlineView class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvOutlineView class >> defaultTitle [

	^ 'Outline'
]

{ #category : #initialization }
PvOutlineView >> connectPresenters [

	outlineTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self announceSelectionChanged: aSelection ].
	outlineTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self announceActivated: aSelection ]
]

{ #category : #'events - handling' }
PvOutlineView >> entityActivated: ann [

	ann model accept: self
]

{ #category : #'events - handling' }
PvOutlineView >> entitySelected: ann [

	ann model accept: (PvOutlineSelectionVisitor new 
		presenter: self;
		yourself)
]

{ #category : #initialization }
PvOutlineView >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (outlineTreePresenter := self newTreeTable);
		yourself).

	outlineTreePresenter
		hideColumnHeaders;
		addStyle: 'stTree';
		addColumn: (SpCompositeTableColumn new 
			addColumn: ( SpImageTableColumn  new 
				evaluated: [ :aModel | self iconNamed: aModel iconName ];
				beNotExpandable;
				yourself);
			addColumn: ( SpStringTableColumn new 
				evaluated: [ :aModel | aModel name ];
				displayColor: [ :aModel | self colorNamed: aModel colorName ];
				yourself);
			"addColumn: ( SpStringTableColumn new 
				evaluated: [ :aModel | 'test' ];
				displayColor: [ :aModel | Color red ];
				displayAlignment: [ :aModel | SpColumnAlignment right ];
				yourself);"
			yourself);
		children: [ :aModel | aModel children ];
		addNavigationShortcuts.
		
	outlineTreePresenter addStyle: 'stProjectTree'
]

{ #category : #'private - accessing' }
PvOutlineView >> treePresenter [

	^ outlineTreePresenter
]

{ #category : #initialization }
PvOutlineView >> updatePresenter [

	self model ifNil: [ ^ self ].
	outlineTreePresenter roots: self model children.
	self withTileWindowDo: [ :w | 
		w title: self title.
		w windowIcon: (self iconNamed: self model windowIconName) ]
]

{ #category : #visiting }
PvOutlineView >> visitClassModel: aModel [

	self model: (PvOutlineClassModel newEntity: aModel entity).
	self updatePresenter
]
