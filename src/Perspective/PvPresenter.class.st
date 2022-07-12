Class {
	#name : #PvPresenter,
	#superclass : #SgaPresenter,
	#category : #'Perspective-View'
}

{ #category : #initialization }
PvPresenter >> addGlobalShortcutsTo: aWindowPresenter [
	
	self globalShortcuts ifNotNil: [ :shortcutCategory |
		self 
			addShortcutCategory: shortcutCategory
			to: aWindowPresenter ]
]

{ #category : #initialization }
PvPresenter >> addShortcutCategory: aCategory to: aPresenter [

	aCategory allEntries keymaps do: [ :each | 
		aPresenter 
			bindKeyCombination: each shortcut
			toAction: each action ]
]

{ #category : #accessing }
PvPresenter >> boxWindowClass [

	^ PvBoxWindowPresenter
]

{ #category : #private }
PvPresenter >> buildIcon: aBlock [
	| compositeIcon |
	
	compositeIcon := PvCompositeIcon new.
	aBlock value: compositeIcon.
	^ compositeIcon buildOn: self application
]

{ #category : #private }
PvPresenter >> colorNamed: aString [

	self flag: #TODO. "Hardcoded. This has to be part of StPharoApplication"
	aString ifNil: [ ^ Smalltalk ui theme textColor ].
	^ Color named: aString
]

{ #category : #initialization }
PvPresenter >> globalShortcuts [

	^ nil
]

{ #category : #scripting }
PvPresenter >> newCode [

	^ super newCode
		systemNavigation: self application systemNavigation;
		yourself
]

{ #category : #scripting }
PvPresenter >> newEntityTree [

	^ self newTree
		addStyle: 'stTree';
		display: [ :aModel | aModel name ];
		displayIcon: [ :aModel | aModel iconComposite buildOn: self application ];
		displayColor: [ :aModel | self colorNamed: aModel colorName ];
		children: [ :aModel | aModel children ];
		searchMatching: [ :anEntity :pattern | anEntity matches: pattern ];
		addNavigationShortcuts;
		yourself
]

{ #category : #initialization }
PvPresenter >> settings [

	^ self application settings
]

{ #category : #accessing }
PvPresenter >> tabWindowClass [

	^ PvTabWindowPresenter
]
