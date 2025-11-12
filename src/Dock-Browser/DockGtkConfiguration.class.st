Class {
	#name : 'DockGtkConfiguration',
	#superclass : 'LnPharoGtkConfiguration',
	#instVars : [
		'styleManager',
		'announcer'
	],
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'private' }
DockGtkConfiguration >> announceSyntaxHighlightThemeChanged [

	self announcer announce: (DockSyntaxHighlightThemeChanged new
		newTheme: self syntaxHighlightThemeName;
		yourself)
]

{ #category : 'private' }
DockGtkConfiguration >> announceThemeChanged [

	self announcer announce: DockThemeChanged new
]

{ #category : 'private' }
DockGtkConfiguration >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

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
	self addCSSProviderFromString: self style.
	
	GRunLoop defer: [
		self styleManager
			"disconnect all possible signal (if I am reconfiguring, 
			 this can be not nil nor empty)"
			disconnectAll; 
			connectNotifyDark: [ self themeChanged ] ].
			
	self announcer
		when: DockThemeChanged send: #resendAnnouncement: to: anApplication;
		when: DockSyntaxHighlightThemeChanged send: #syntaxHighlightThemeChanged: to: anApplication
]

{ #category : 'accessing' }
DockGtkConfiguration >> darkColorsForTestResult [

	^ SmallDictionary newFromPairs: {
		#passed. 	'LightGreen'.
		#failure. 	'DarkOrange'.
		#error.  	'Tomato' }
]

{ #category : 'accessing - style' }
DockGtkConfiguration >> darkPaletteStyle [

	^ '
:root {
	/* testing */
	--test-passed: 	LightGreen;
	--test-error: 	Tomato;
	--test-failure: DarkOrange;
	/* repositories */
	--repository-modified: LightGreen;
	--repository-error: Tomato;	
	/* markers for editor */
	--button-bg-cancel-mark: #FF00006F;
	--button-bg-accept-mark: #00DF006F;
}	
'
]

{ #category : 'accessing' }
DockGtkConfiguration >> forceDark [

	self reset.
	GRunLoop defer: [ self styleManager ensureDark ].
	self resetTheme
]

{ #category : 'accessing' }
DockGtkConfiguration >> forceLight [

	self reset.
	GRunLoop defer: [ self styleManager ensureLight ].
	self resetTheme
]

{ #category : 'initialization' }
DockGtkConfiguration >> initialize [

	self resetTheme.		
	super initialize
]

{ #category : 'testing' }
DockGtkConfiguration >> isDarkTheme [
	
	^ GRunLoop defer: [ self styleManager isDark ]
]

{ #category : 'accessing' }
DockGtkConfiguration >> lightColorsForTestResult [

	^ SmallDictionary newFromPairs: {
		#passed. 	'Green'.
		#failure. 	'Orange'.
		#error.  	'Red' }
]

{ #category : 'accessing - style' }
DockGtkConfiguration >> lightPaletteStyle [

	^ '
:root {
	/* testing */
	--test-passed: green;
	--test-error: red;
	--test-failure: orange;
	/* repositories */
	--repository-modified: green;
	--repository-error: red;
	/* markers for editor */
	--button-bg-cancel-mark: #C000002F; 
	--button-bg-accept-mark: #00C0002F;
}	
'
]

{ #category : 'accessing - style' }
DockGtkConfiguration >> paletteStyle [

	^ self isDarkTheme
		ifTrue: [ self darkPaletteStyle ]
		ifFalse: [ self lightPaletteStyle ]
]

{ #category : 'accessing' }
DockGtkConfiguration >> preferDark [

	self reset.
	GRunLoop defer: [ self styleManager preferDark ].
	self resetTheme
]

{ #category : 'accessing' }
DockGtkConfiguration >> preferLight [

	self reset.
	GRunLoop defer: [ self styleManager preferLight ].
	self resetTheme
]

{ #category : 'configuring' }
DockGtkConfiguration >> reloadOnApplication: anApplication [ 

	^ self configure: anApplication
]

{ #category : 'private' }
DockGtkConfiguration >> resetDefaultSyntaxHighlightForTheme [

	syntaxHighlightThemeName := nil.
	styleScheme := nil
]

{ #category : 'private' }
DockGtkConfiguration >> resetTheme [

	self theme: (self isDarkTheme
		ifTrue: [ LnDarkTheme new ]
		ifFalse: [ LnLightTheme new ])
]

{ #category : 'accessing - style' }
DockGtkConfiguration >> style [

	^ ' 
toast { border-radius: 4px; padding: 0px 8px; }
panelframeswitcher { margin: 2px; min-height: 20px; min-width: 20px; }
panelframeswitcher button { border: 1px; border-radius: 4px; box-shadow: none; }
panelframetabbar { min-height: 0px; padding: 0px; margin: 0px; }
panelframetabbar tabbar tabboxchild { border-radius: 0px; }
panelframetabbar tabbar tabboxchild tab { min-height: 0px; padding: 2px; border: 1px; border-radius: 4px; box-shadow: none; }
panelframetabbar tabbar tabboxchild tab:selected { background-color: alpha(@accent_bg_color, 0.85); color: @accent_fg_color; }
panelframetabbar tabbar widget.end-action  { min-height: 0px; padding: 0px; margin: 0px; }
paneldock listview { background-color: var(--window-bg-color); }
paneldock box.dockToolbarPanel { background-color: var(--window-bg-color); }
panelgrid listview { background-color: var(--view-bg-color); } /* reset central part so I can see clear */
paneldock panelframe popover listview { background-color: var(--view-bg-color); }
paneldock panelframe popover box.dockToolbarPanel { background-color: unset; }

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
.dockProjectView .modified { color: green; }

.dockProtocolRow label.unclassified { color: red; }
.dockStack label.count { padding-right: 5px; }
.dockToolbar { margin: 0px; padding: 0px; }

.dockDirtyMarker button { padding: 2px; }
.dockDirtyMarker .cancel { background-color: var(--button-bg-cancel-mark); }
.dockDirtyMarker .accept { background-color: var(--button-bg-accept-mark); }
.dockEditorBreadcrumb { font-size: 9pt; }
.dockEditorBreadcrumb label.separator { padding: 0px 5px 0px 5px; }
popover .dockPreviewEditor { min-width: 680px; min-height: 340px; }
.dockBrowser { }
.dockDialog, .dockFlyingBrowser { margin: 5px; border-spacing: 5px; }

.dockSpotter { margin: 5px; border-spacing: 5px; min-width: 700px; }
.dockSpotter entry.search { margin: 15px 10px 5px 10px; }

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
/* Repositories (I can also have .notLoaded and .upToDate) */
.dockRepositories .dockRepositoryRow .missing { color: var(--repository-error); }
.dockRepositories .dockRepositoryRow .modified { color: var(--repository-modified); }
.dockRepositories .dockRepositoryRow .error { color: var(--repository-error); }

'
]

{ #category : 'private' }
DockGtkConfiguration >> styleManager [

	styleManager isNullOrNil 
		ifTrue: [ styleManager := AdwStyleManager default ].
	
^ styleManager
]

{ #category : 'accessing - style' }
DockGtkConfiguration >> styleScheme: aString [

	super styleScheme: aString.
	self announceThemeChanged
]

{ #category : 'accessing - style' }
DockGtkConfiguration >> syntaxHighlightTheme: aName [

	super syntaxHighlightTheme: aName.
	self announceSyntaxHighlightThemeChanged
]

{ #category : 'accessing' }
DockGtkConfiguration >> syntaxHighlightThemeName [

	^ syntaxHighlightThemeName ifNil: [ 
		syntaxHighlightThemeName := self isDarkTheme
			ifTrue: [ self syntaxHighlightThemeNameDark ]
			ifFalse: [ self syntaxHighlightThemeNameLight ] ]
]

{ #category : 'accessing' }
DockGtkConfiguration >> syntaxHighlightThemeNameDark [
	
	^ 'GitHubDark'
]

{ #category : 'accessing' }
DockGtkConfiguration >> syntaxHighlightThemeNameLight [
	
	^ 'GitHubLight' "'Blue' 'Vintage' 'Tango' 'Solarized'"
]

{ #category : 'private' }
DockGtkConfiguration >> themeChanged [

	self resetDefaultSyntaxHighlightForTheme.
	self announceThemeChanged.
	self announceSyntaxHighlightThemeChanged.
]
