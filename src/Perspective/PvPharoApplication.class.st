Class {
	#name : #PvPharoApplication,
	#superclass : #LnPharoApplication,
	#instVars : [
		'name'
	],
	#category : #'Perspective-Application'
}

{ #category : #accessing }
PvPharoApplication >> boxWindowClass [

	^ PvBoxWindowPresenter
]

{ #category : #'private - factory' }
PvPharoApplication >> newIconProvider [

	^ (PvAliasedVSCodeIconProvider new
			application: self;
			addLocation: (FileLocator imageDirectory / 'vscode-extraicons') asFileReference;
			addLocation: (FileLocator imageDirectory / 'vscode-icons') asFileReference;
			addLocation: (FileLocator imageDirectory / 'vscode-codicons') asFileReference;
			yourself),
	 (PvLocationWithThemeIconProvider new
			application: self;
			addLocation: (FileLocator imageDirectory / 'idea-extraicons') asFileReference;
			addLocation: (FileLocator imageDirectory / 'idea-icons') asFileReference;
			yourself),
	  StPharoDefaultIconProvider new, 
	  SgaGtkThemeIconProvider new,
	  PvDefaultIconProvider new
]

{ #category : #'private - factory' }
PvPharoApplication >> newSettings [

	^ PvActionSettings new
		"this can change by platform (linux, mac or windows)"
		mod1: Smalltalk os mod1;
		mod2: Smalltalk os mod2;
		mod3: Smalltalk os mod3;
		yourself
]

{ #category : #'instance creation' }
PvPharoApplication >> newSystemTools [

	^ super newSystemTools
		register: MessageBrowser as: #messageList;
		yourself
]

{ #category : #running }
PvPharoApplication >> start [

	"nothing for the moment"
]

{ #category : #accessing }
PvPharoApplication >> tabWindowClass [

	^ PvTabWindowPresenter
]

{ #category : #settings }
PvPharoApplication >> toolbarDisplayMode [

	^ SpToolbarDisplayMode modeIcon
]

{ #category : #initialization }
PvPharoApplication >> useGtkLight [

	self 
		useBackend: #Gtk 
		with: PvPharoGtkConfiguration new
]
