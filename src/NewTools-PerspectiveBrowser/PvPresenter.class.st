Class {
	#name : #PvPresenter,
	#superclass : #SgaPresenter,
	#category : #'NewTools-PerspectiveBrowser-View'
}

{ #category : #accessing }
PvPresenter >> boxWindowClass [

	^ PvBoxWindowPresenter
]

{ #category : #private }
PvPresenter >> colorNamed: aString [

	self flag: #TODO. "Hardcoded. This has to be part of StPharoApplication"
	aString ifNil: [ ^ Smalltalk ui theme textColor ].
	^ Color named: aString
]

{ #category : #initialization }
PvPresenter >> initializeToolbar: aToolbarPresenter [ 

]

{ #category : #scripting }
PvPresenter >> newEntityTree [

	^ self newTree
		addStyle: 'stTree';
		display: [ :aModel | aModel name ];
		displayIcon: [ :aModel | self iconNamed: aModel iconName ];
		displayColor: [ :aModel | self colorNamed: aModel colorName ];
		children: [ :aModel | aModel children ];
		addNavigationShortcuts;
		yourself
]

{ #category : #accessing }
PvPresenter >> tabWindowClass [

	^ PvTabWindowPresenter
]
