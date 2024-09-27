Trait {
	#name : 'PvTScripting',
	#category : 'Perspective-View',
	#package : 'Perspective',
	#tag : 'View'
}

{ #category : 'building' }
PvTScripting >> buildPerspectiveToolbarWith: aBlock [

	^ (PvContextActionBuilder on: self) buildToolbarWith: aBlock
]

{ #category : 'scripting' }
PvTScripting >> newCode [

	^ super newCode
		systemNavigation: self systemNavigation;
		yourself
]

{ #category : 'scripting' }
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

{ #category : 'scripting' }
PvTScripting >> newPerspectiveViewToolbar: aGroup [

	^ self 
		newPerspectiveViewToolbar: aGroup 
		actions: nil
]

{ #category : 'scripting' }
PvTScripting >> newPerspectiveViewToolbar: groups actions: actionGroups [

	^ self buildPerspectiveToolbarWith: [ :builder |
		builder 
			mainGroups: groups;
			actionGroups: actionGroups ]
]
