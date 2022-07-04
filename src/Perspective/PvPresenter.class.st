Class {
	#name : #PvPresenter,
	#superclass : #SgaPresenter,
	#category : #'Perspective-View'
}

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

{ #category : #accessing }
PvPresenter >> tabWindowClass [

	^ PvTabWindowPresenter
]
