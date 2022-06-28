Class {
	#name : #PvOutlinePresenter,
	#superclass : #PvContainedPresenter,
	#instVars : [
		'classTreePresenter',
		'outlineTreePresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Outline'
}

{ #category : #accessing }
PvOutlinePresenter class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvOutlinePresenter class >> defaultTitle [

	^ 'Outline'
]

{ #category : #initialization }
PvOutlinePresenter >> connectPresenters [

	outlineTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self announceSelectionChanged: aSelection ].
	outlineTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self announceActivated: aSelection ]
]

{ #category : #'events - handling' }
PvOutlinePresenter >> entityActivated: ann [

	ann model accept: self
]

{ #category : #'events - handling' }
PvOutlinePresenter >> entitySelected: ann [

	outlineTreePresenter selectedItem = ann model 
		ifTrue: [ ^ self ].

	outlineTreePresenter selectItem: ann model
]

{ #category : #initialization }
PvOutlinePresenter >> initializePresenters [

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
"			addColumn: ( SpStringTableColumn new 
				evaluated: [ :aModel | 'test' ];
				displayColor: [ :aModel | Color red ];
				displayAlignment: [ :aModel | SpColumnAlignment right ];
				yourself);			"
			yourself );
		children: [ :aModel | aModel children ];
		addNavigationShortcuts.
		
	outlineTreePresenter addStyle: 'stProjectTree'
]

{ #category : #initialization }
PvOutlinePresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	outlineTreePresenter roots: self model children.
	self withTileWindowDo: [ :w | w title: self title ]
]

{ #category : #visiting }
PvOutlinePresenter >> visitClassModel: aModel [

	self model: (PvOutlineClassModel newEntity: aModel entity).
	self updatePresenter
]
