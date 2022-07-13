Trait {
	#name : #PvTScripting,
	#category : #'Perspective-View'
}

{ #category : #scripting }
PvTScripting >> newCode [

	^ super newCode
		systemNavigation: self application systemNavigation;
		yourself
]

{ #category : #scripting }
PvTScripting >> newEntityTree [

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

{ #category : #scripting }
PvTScripting >> newPerspectiveViewToolbar: aGroup [

	^ self 
		newPerspectiveViewToolbar: aGroup 
		actions: nil
]

{ #category : #scripting }
PvTScripting >> newPerspectiveViewToolbar: groups actions: actionGroups [
	| presenter |

	presenter := self newPresenter.
	presenter layout: SpBoxLayout newLeftToRight.	
	
	presenter layout add: (presenter newToolbar
		addStyle: 'pvPerspectiveToolbar';
		displayMode: self application toolbarDisplayMode;
		fillWith: (PvCommand 
			buildToolbar: groups 
			on: self)).
			
	actionGroups ifNotNil: [ 
		presenter layout 
			addLast: (presenter newToolbar
				addStyle: 'pvPerspectiveToolbar';
				displayMode: self application toolbarDisplayMode;
				fillWith: (PvCommand 
					buildToolbar: actionGroups 
					on: self))
			expand: false ].
			
	^ presenter
]
