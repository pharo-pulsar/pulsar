Class {
	#name : 'DockGtkConfiguration',
	#superclass : 'LnPharoGtkConfiguration',
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'configuring' }
DockGtkConfiguration >> configureGeneral: anApplication [

	super configureGeneral: anApplication.
	self addCSSProviderFromString: self style
]

{ #category : 'initialization' }
DockGtkConfiguration >> initialize [

	super initialize.
	self theme: LnDarkTheme new
]

{ #category : 'accessing' }
DockGtkConfiguration >> style [

	^ '	
.stList listview, .stTree listview { 
	font-size: 0.9em;
} 
.stTree columnview listview row cell {
	margin: 0px;
	padding: 2px;
}
.stTree columnview listview row cell box { 
	border-spacing: 5px;
}
.searchBox { background-color: @popover_bg_color; }
.link { padding: 0px; }
.cell-link { font-size: smaller; font-weight: normal; color: gray; min-width: 10px; }
.pvEditorScrollBar { min-height: 150px; }
.pvNavigation { min-width: 450px; min-height: 350px; padding: 5px; }
button.pvProtocol { font-weight: normal; }
.pvProtocolChooser { min-width: 250px; min-height: 280px; }
.stCode { font-size: 0.95em; }
.dockEditorBreadcrumb { 
	font-size: 0.9em;
}
.dockEditorBreadcrumb label.separator {
	padding: 0px 5px 0px 5px;
}
'
]
