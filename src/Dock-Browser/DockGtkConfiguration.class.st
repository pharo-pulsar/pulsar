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

{ #category : 'accessing' }
DockGtkConfiguration >> forceDark [

	self reset.
	GRunLoop defer: [ AdwStyleManager default ensureDark ].
	self theme: LnLightTheme new
]

{ #category : 'accessing' }
DockGtkConfiguration >> forceLight [

		GRunLoop defer: [ AdwStyleManager default ensureLight ].
	self theme: LnLightTheme new
]

{ #category : 'initialization' }
DockGtkConfiguration >> initialize [

	self theme: (self isDarkTheme
		ifTrue: [ LnDarkTheme new ]
		ifFalse: [ LnLightTheme new ]).
		
	super initialize
]

{ #category : 'testing' }
DockGtkConfiguration >> isDarkTheme [
	
	^ GRunLoop defer: [ AdwStyleManager default isDark ]
]

{ #category : 'accessing' }
DockGtkConfiguration >> style [

	^ '
.stList listview, .stTree listview { font-size: 0.9em; } 
.stTree columnview listview row cell { margin: 0px; padding: 2px; }
.stTree columnview listview row cell box { border-spacing: 5px; }
.stRow { margin: 3px; border-spacing: 3px; }
.tinyFont {font-size: 0.7em; }
.searchBox { background-color: @popover_bg_color; }
.link { padding: 0px; }
.cell-link { font-size: smaller; font-weight: normal; color: gray; min-width: 10px; }
.pvEditorScrollBar { min-height: 150px; }
.pvNavigation { min-width: 450px; min-height: 350px; padding: 5px; }
button.pvProtocol { font-weight: normal; }
.pvProtocolChooser { min-width: 250px; min-height: 280px; }
/* .stCode { font-family: monospace; font-size: 0.95em; } */
tab .tab-title label { font-size: 0.9em; }
.dockToolbar { margin: 0px; padding: 0px; }
.dockEditorBreadcrumb { font-size: 9pt; }
.dockEditorBreadcrumb label.separator { padding: 0px 5px 0px 5px; }
.dockSpotter, .dockDialog, .dockFlyingBrowser { margin: 5px; border-spacing: 5px; }
.dockSpotter entry.search { margin: 5px 5px 0px 5px; }
.dockMessageFlyingBrowser { min-width: 680px; min-height: 440px; }
.dockInspectorFlyingBrowser { min-width: 680px; min-height: 440px; }
.dockHierarchyFlyingBrowser { min-width: 450px; min-height: 350px; }
.dockPopoverControlToolbar { margin: 0px; padding: 0px 0px 0px 10px; }
'
]
