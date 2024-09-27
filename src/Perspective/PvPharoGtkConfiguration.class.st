Class {
	#name : 'PvPharoGtkConfiguration',
	#superclass : 'LnPharoGtkConfiguration',
	#category : 'Perspective-Application',
	#package : 'Perspective',
	#tag : 'Application'
}

{ #category : 'configuring' }
PvPharoGtkConfiguration >> configureGeneral: anApplication [

	super configureGeneral: anApplication.
	self addCSSProviderFromString: self style
]

{ #category : 'initialization' }
PvPharoGtkConfiguration >> initialize [

	super initialize.
	self theme: LnDarkTheme new
]

{ #category : 'configuring' }
PvPharoGtkConfiguration >> style [

	^ '
listview { 
	font-size: 0.9em;
} 
columnview listview row cell {
	margin: 0px;
	padding: 2px;
}
columnview listview row cell box { 
	border-spacing: 5px;
}
.link { padding: 0px; }
.cell-link { font-size: smaller; font-weight: normal; color: gray; min-width: 10px; }
.pvEditorScrollBar { min-height: 150px; }
.pvNavigation { min-width: 450px; min-height: 350px; padding: 5px; }
button.pvProtocol { font-weight: normal; }
.pvProtocolChooser { min-width: 200px; min-height: 280px; }
'
]
