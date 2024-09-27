Class {
	#name : 'PvPharoApplication',
	#superclass : 'LnPharoApplication',
	#instVars : [
		'name'
	],
	#category : 'Perspective-Application',
	#package : 'Perspective',
	#tag : 'Application'
}

{ #category : 'accessing' }
PvPharoApplication >> boxWindowClass [

	^ PvBoxWindowPresenter
]

{ #category : 'accessing' }
PvPharoApplication >> colorNamed: aString [

	aString ifNil: [ ^ Smalltalk ui theme textColor ].
	^ Color named: aString
]

{ #category : 'accessing' }
PvPharoApplication >> iconCache [

	^ self 
		propertyAt: #iconCache 
		ifAbsentPut: [ PvCompositeIconCache new ]
]

{ #category : 'private - factory' }
PvPharoApplication >> newIconProvider [

	^ (PvAliasedVSCodeIconProvider new
			application: self;
			addLocation: (FileLocator imageDirectory / 'perspective' / 'vscode-extraicons') asFileReference;
			addLocation: (FileLocator imageDirectory / 'perspective' / 'vscode-icons') asFileReference;
			addLocation: (FileLocator imageDirectory / 'perspective' / 'vscode-codicons') asFileReference;
			yourself),
	 (PvLocationWithThemeIconProvider new
			application: self;
			addLocation: (FileLocator imageDirectory / 'perspective' / 'idea-extraicons') asFileReference;
			addLocation: (FileLocator imageDirectory / 'perspective' / 'idea-icons') asFileReference;
			yourself),
	  StPharoDefaultIconProvider new, 
	  SgaGtkThemeIconProvider new,
	  PvDefaultIconProvider new
]

{ #category : 'private - factory' }
PvPharoApplication >> newSettings [

	^ PvActionSettings new
		"this can change by platform (linux, mac or windows)"
		mod1: Smalltalk os mod1;
		mod2: Smalltalk os mod2;
		mod3: Smalltalk os mod3;
		yourself
]

{ #category : 'private - factory' }
PvPharoApplication >> newSystemTools [

	^ super newSystemTools
		register: StMessageBrowser as: #messageList;
		yourself
]

{ #category : 'running' }
PvPharoApplication >> start [

	"nothing for the moment"
]

{ #category : 'accessing' }
PvPharoApplication >> tabWindowClass [

	^ PvTabWindowPresenter
]

{ #category : 'settings' }
PvPharoApplication >> toolbarDisplayMode [

	^ SpToolbarDisplayMode modeIcon
]

{ #category : 'initialization' }
PvPharoApplication >> useGtkDark [

	self 
		useBackend: #Gtk 
		with: (PvPharoGtkConfiguration new
			theme: LnDarkTheme new;
			yourself)
]

{ #category : 'initialization' }
PvPharoApplication >> useGtkLight [

	self 
		useBackend: #Gtk 
		with: PvPharoGtkConfiguration new
]
