Class {
	#name : 'DockGtkConfiguration',
	#superclass : 'LnPharoGtkConfiguration',
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'accessing' }
DockGtkConfiguration >> colorsForTestResult [

	^ self isDarkTheme
		ifTrue: [ self darkColorsForTestResult ]
		ifFalse: [ self lightColorsForTestResult ]
]

{ #category : 'configuring' }
DockGtkConfiguration >> configureGeneral: anApplication [

	super configureGeneral: anApplication.
	self addCSSProviderFromString: self paletteStyle.
	self addCSSProviderFromString: self style
]

{ #category : 'accessing' }
DockGtkConfiguration >> darkColorsForTestResult [

	^ SmallDictionary newFromPairs: {
		#passed. 	'LightGreen'.
		#failure. 	'DarkOrange'.
		#error.  	'Tomato' }
]

{ #category : 'configuring' }
DockGtkConfiguration >> darkPaletteStyle [

	^ '
:root {
	--test-passed: 	LightGreen;
	--test-error: 	Tomato;
	--test-failure: DarkOrange;
}	
'
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
DockGtkConfiguration >> lightColorsForTestResult [

	^ SmallDictionary newFromPairs: {
		#passed. 	'Green'.
		#failure. 	'Orange'.
		#error.  	'Red' }
]

{ #category : 'configuring' }
DockGtkConfiguration >> lightPaletteStyle [

	^ '
:root {
	--test-passed: 	Green;
	--test-error: 	Red;
	--test-failure: Orange;
}	
'
]

{ #category : 'configuring' }
DockGtkConfiguration >> paletteStyle [

	^ self isDarkTheme
		ifTrue: [ self darkPaletteStyle ]
		ifFalse: [ self lightPaletteStyle ]
]

{ #category : 'configuring' }
DockGtkConfiguration >> reloadOnApplication: anApplication [ 

	^ self configure: anApplication
]

{ #category : 'accessing' }
DockGtkConfiguration >> style [

	^ '
/* listview { background-color: var(--window-bg-color); } */
.stList listview, .stTree listview { font-size: 0.9em; } 
.stTree columnview listview row cell { margin: 0px; padding: 2px; }
.stTree columnview listview row cell box { border-spacing: 5px; }
.stRow { margin: 2px; border-spacing: 2px; }
.tinyFont {font-size: 0.7em; }
.searchBox { background-color: @popover_bg_color; }
.link { padding: 0px; }
.cell-link { font-size: smaller; font-weight: normal; color: gray; min-width: 10px; }
.pvEditorScrollBar { min-height: 150px; }
.pvNavigation { min-width: 450px; min-height: 350px; padding: 5px; }
button.pvProtocol { font-weight: normal; }
.pvProtocolChooser { min-width: 250px; min-height: 280px; }
tab .tab-title label { font-size: 0.9em; }
.dockProtocolRow label.unclassified { color: red; }
.dockStack label.count { padding-right: 5px; }
.dockToolbar { margin: 0px; padding: 0px; }
.dockEditorBreadcrumb { font-size: 9pt; }
.dockEditorBreadcrumb label.separator { padding: 0px 5px 0px 5px; }
popover .dockPreviewEditor { min-width: 680px; min-height: 340px; }
.dockBrowser { }
.dockDialog, .dockFlyingBrowser, .dockSpotter { margin: 5px; border-spacing: 5px; }
.dockSpotter entry.search { margin: 5px 5px 0px 5px; }
.dockMessageFlyingBrowser { min-width: 680px; min-height: 440px; }
.dockInspectorFlyingBrowser { min-width: 680px; min-height: 440px; }
.dockHierarchyFlyingBrowser { min-width: 450px; min-height: 350px; }
.dockVersionsFlyingBrowser { min-width: 680px; min-height: 440px; }
.dockFlyingBrowser notebook tabs tab { padding: 2px; }
.dockFlyingBrowser notebook tabs tab label { font-size: 0.9em }
.dockPopoverControlToolbar { margin: 0px; padding: 0px 0px 0px 10px; }
.dockDebuggerToolbar { background-color: var(--window-bg-color); }
.dockDebuggerToolbar .stToolbar { padding: 1px; }
.dockPlaygroundBindingsFlyingBrowser { min-width: 280px; min-height: 240px; }
/***
 * METHOD DECORATIONS 
 */
.dockMethodRow .trait { 
	font-style: italic;  
	text-decoration-line: underline;
}
.dockMethodRow .abstract { 
	text-decoration-line: underline;
	text-decoration-style: double;
}
.dockMethodRow .extension { 
	font-style: italic; 
	text-decoration-line: underline;
	text-decoration-style: dotted;
}
.dockMethodRow .test-unknown { }
.dockMethodRow .test-passed { color: var(--test-passed); }
.dockMethodRow .test-error { color: var(--test-error); }
.dockMethodRow .test-failure { color: var(--test-failure); }

'
]
