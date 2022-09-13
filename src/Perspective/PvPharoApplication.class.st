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

	^ (PvLocationWithThemeIconProvider new
			application: self;
			addLocation: './new-icons' asFileReference;
			addLocation: './idea-community-icons' asFileReference;
			yourself),
	  StPharoDefaultIconProvider new, 
	  SgaGtkThemeIconProvider new,
	  PvDefaultIconProvider new
]

{ #category : #'private - factory' }
PvPharoApplication >> newSettings [

	self flag: #TODO. "Take this from better settings"
	
	^ LnSettings new
		"this can change by platform (linux, mac or windows)"
		mod1: Smalltalk os mod1;
		mod2: Smalltalk os mod2;
		mod3: Smalltalk os mod3;
		"I need a better way to do this (extensible, yet comprensible)"
		defineShortcutGroup: #perspective with: { 
			"open default tool"
			KeyboardKey enter 	shift 			-> [ :perspective | perspective showSpotterForWindows ].
			KeyboardKey enter 	ctrl 			-> [ :perspective | perspective showSpotterForEnvironment ].
			KeyboardKey enter 	alt 			-> [ :perspective | perspective showSpotterForCommands ].
		};
		defineShortcutGroup: #container with: { 
			"moving into workspace windows"
			KeyboardKey up 		mod3 shift  -> [ :container | container focusUp ].
			KeyboardKey down 	mod3 shift  -> [ :container | container focusDown ].
			KeyboardKey left 	mod3 shift  -> [ :container | container focusLeft ].
			KeyboardKey right 	mod3 shift  -> [ :container | container focusRight ].
			"rotate layouts"
			$r mod3 -> [ :container | container rotateContainerLayout ].
			"switch layouts"
			$v mod3 -> [ :container | container useVerticalLayout ].
			$h mod3 -> [ :container | container useHorizontalLayout ].
			$t mod3 -> [ :container | container useTabLayout ].
			"split container inserting layout"
			$v mod3 shift -> [ :container | container splitContainerVerticalLayout ].
			$h mod3 shift -> [ :container | container splitContainerHorizontalLayout ].
			$t mod3 shift -> [ :container | container splitContainerTabLayout ].
		};
		defineShortcutGroup: #window with: { 
			$w mod1 -> [ :window | window close ].
			"$f mod1 shift -> [ :window | window toggleFullScreen ].
			$t mod1 shift -> [ :window | window showContainerContextMenu ]."
		}.
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
