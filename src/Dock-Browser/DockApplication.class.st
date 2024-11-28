Class {
	#name : 'DockApplication',
	#superclass : 'StPharoApplication',
	#instVars : [
		'name'
	],
	#category : 'Dock-Browser-Base',
	#package : 'Dock-Browser',
	#tag : 'Base'
}

{ #category : 'accessing' }
DockApplication >> colorNamed: aString [

	aString ifNil: [ ^ Smalltalk ui theme textColor ].
	^ Color named: aString
]

{ #category : 'accessing' }
DockApplication >> iconCache [

	^ self 
		propertyAt: #iconCache 
		ifAbsentPut: [ PvCompositeIconCache new ]
]

{ #category : 'settings' }
DockApplication >> isShowingLineNumbers [

	^ true
]

{ #category : 'initialization' }
DockApplication >> newConfiguration [

	^ PvPharoGtkConfiguration new
		applicationId: 'org.pharo.Dock';
		applicationClass: PanelApplication;
		yourself
]

{ #category : 'private - factory' }
DockApplication >> newIconProvider [

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
DockApplication >> newSettings [

	^ PvActionSettings new
		"this can change by platform (linux, mac or windows)"
		mod1: Smalltalk os mod1;
		mod2: Smalltalk os mod2;
		mod3: Smalltalk os mod3;
		yourself
]

{ #category : 'private - factory' }
DockApplication >> newSystemTools [

	^ Smalltalk tools deepCopy
		register: StMessageBrowser as: #messageList;
		yourself
]

{ #category : 'running' }
DockApplication >> start [

	(self new: DockBrowser) open
]

{ #category : 'settings' }
DockApplication >> toolbarDisplayMode [

	^ SpToolbarDisplayMode modeIcon
]

{ #category : 'initialization' }
DockApplication >> useGtkDark [

	self 
		useBackend: #Gtk 
		with: (self newConfiguration
			theme: LnDarkTheme new;
			yourself)
]

{ #category : 'initialization' }
DockApplication >> useGtkLight [

	self 
		useBackend: #Gtk 
		with: self newConfiguration
]
