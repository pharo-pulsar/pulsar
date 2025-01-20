Class {
	#name : 'DockGtkConfiguration',
	#superclass : 'LnPharoGtkConfiguration',
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'configuring' }
DockGtkConfiguration >> configureGeneral: anApplication [

	self theme isDarkTheme 
		ifTrue: [ GRunLoop defer: [ AdwStyleManager default ensureDark ] ]
		ifFalse: [ GRunLoop defer: [ AdwStyleManager default ensureLight ] ].

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
.stRow {
	margin: 3px;
	border-spacing: 3px;	
}
.tinyFont {
	font-size: 0.7em;
}
.searchBox { background-color: @popover_bg_color; }
.link { padding: 0px; }
.cell-link { font-size: smaller; font-weight: normal; color: gray; min-width: 10px; }
.pvEditorScrollBar { min-height: 150px; }
.pvNavigation { min-width: 450px; min-height: 350px; padding: 5px; }
button.pvProtocol { font-weight: normal; }
.pvProtocolChooser { min-width: 250px; min-height: 280px; }
.stCode { font-size: 0.95em; }
.dockEditorBreadcrumb { font-size: 0.9em; }
.dockEditorBreadcrumb label.separator { padding: 0px 5px 0px 5px; }
.dockSpotter, .dockDialog, .dockFlyingBrowser { margin: 5px; border-spacing: 5px; }
.dockMessageFlyingBrowser { min-width: 620px; min-height: 420px; }
.dockInspectorFlyingBrowser { min-width: 420px; min-height: 420px; }
.dockPopoverControlToolbar { margin: 0px; padding: 0px; }
'
]
