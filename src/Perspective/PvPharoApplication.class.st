Class {
	#name : #PvPharoApplication,
	#superclass : #LnPharoApplication,
	#instVars : [
		'name'
	],
	#category : #'Perspective-Application'
}

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
		defineShortcutGroup: #perspective with: { 
			"open default tool"
			KeyboardKey enter 	shift 			-> [ :perspective | perspective showSpotter ].
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
			$f mod1 shift -> [ :window | window toggleFullScreen ].
			$t mod1 shift -> [ :window | window showContainerContextMenu ].
		}.
]

{ #category : #accessing }
PvPharoApplication >> start [

	"nothing for the moment"
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
