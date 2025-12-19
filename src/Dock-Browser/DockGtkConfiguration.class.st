Class {
	#name : 'DockGtkConfiguration',
	#superclass : 'StPharoGtkConfiguration',
	#instVars : [
		'settings',
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
		newTheme: self syntaxHighlightTheme;
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

{ #category : 'private - settings' }
DockGtkConfiguration >> applySettings [

	self 
		settingAt: #theme ifPresent: [ :aValue | self applyTheme: aValue ];
		settingAt: #syntaxHighlightTheme ifPresent: [ :aValue | self applySyntaxHighlightTheme: aValue ];
		settingAt: #styleScheme ifPresent: [ :aValue | self appplyStyleScheme: aValue ]
		
]

{ #category : 'private - settings' }
DockGtkConfiguration >> applySyntaxHighlightTheme: aString [

	self syntaxHighlightTheme: aString
]

{ #category : 'private - settings' }
DockGtkConfiguration >> applyTheme: aSymbol [
	"this is a setting before anything... we do not refresh anything as this is the very initial thing to execute"
	| selector |

	selector := #preferSystem.
	aSymbol = #dark ifTrue: [ selector := #forceDark ].
	aSymbol = #light ifTrue: [ selector := #forceLight ].
	
	GRunLoop defer: [ self styleManager perform: selector ]
]

{ #category : 'private - settings' }
DockGtkConfiguration >> appplyStyleScheme: aString [

	self styleScheme: aString
]

{ #category : 'accessing' }
DockGtkConfiguration >> colorsForTestResult [

	^ self isDarkTheme
		ifTrue: [ self darkColorsForTestResult ]
		ifFalse: [ self lightColorsForTestResult ]
]

{ #category : 'configuring' }
DockGtkConfiguration >> configure: anApplication [

	settings := anApplication settings.
	super configure: anApplication
]

{ #category : 'configuring' }
DockGtkConfiguration >> configureGeneral: anApplication [
	
	"first to all, so I have settings available for the rest"
	settings := anApplication settings.
	
	super configureGeneral: anApplication.
	self addCSSProviderFromString: self style.
	
	self announcer
		when: DockThemeChanged send: #resendAnnouncement: to: anApplication;
		when: DockSyntaxHighlightThemeChanged send: #syntaxHighlightThemeChanged: to: anApplication.
		
	"this is important to happen after the subscription because it may end up updating things" 
	self applySettings.
	
	"now that we have settings processed, we apply the palette (as settings can 
	 change the theme, hence the palette)"
	self addCSSProviderFromString: self paletteStyle.
		
	"we are already in a defer, this is just to ensure it" 
	GRunLoop defer: [
		self styleManager
			"disconnect all possible signal (if I am reconfiguring, 
			 this can be not nil nor empty)"
			disconnectAll; 
			connectNotifyDark: [ self themeChanged ] ].
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
	--test-passed: LightGreen;
	--test-error: Tomato;
	--test-failure: DarkOrange;
	/* repositories */
	--repository-modified: LightGreen;
	--repository-detached: DarkOrange;
	--repository-error: Tomato;	
	/* markers for editor */
	--button-bg-cancel-mark: #FF00006F;
	--button-bg-accept-mark: #00DF006F;
	/* repository commit */
	--commit-outgoing: LightGreen;
	--commit-incoming: Yellow;
}
'
]

{ #category : 'private - defaults' }
DockGtkConfiguration >> defaultStyleScheme [

	^ self isDarkTheme
		ifTrue: [ self defaultStyleSchemeDark ]
		ifFalse: [ self defaultStyleSchemeLight ]
]

{ #category : 'private - defaults' }
DockGtkConfiguration >> defaultStyleSchemeDark [

	^ 'Adwaita-dark'
]

{ #category : 'private - defaults' }
DockGtkConfiguration >> defaultStyleSchemeLight [

	^ 'Adwaita'
]

{ #category : 'private - defaults' }
DockGtkConfiguration >> defaultSyntaxHighlightThemeName [

	^ self isDarkTheme
		ifTrue: [ self defaultSyntaxHighlightThemeNameDark ]
		ifFalse: [ self defaultSyntaxHighlightThemeNameLight ]
]

{ #category : 'private - defaults' }
DockGtkConfiguration >> defaultSyntaxHighlightThemeNameDark [
	
	^ 'CodeDark'
]

{ #category : 'private - defaults' }
DockGtkConfiguration >> defaultSyntaxHighlightThemeNameLight [
	
	^ 'CodeLight'
]

{ #category : 'accessing' }
DockGtkConfiguration >> forceDark [

	self reset.
	GRunLoop defer: [ self styleManager forceDark ].
	self resetTheme.
	self settingAt: #theme put: #dark
]

{ #category : 'accessing' }
DockGtkConfiguration >> forceLight [

	self reset.
	GRunLoop defer: [ self styleManager forceLight ].
	self resetTheme.
	self settingAt: #theme put: #light
]

{ #category : 'initialization' }
DockGtkConfiguration >> initialize [

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
	--repository-detached: orange;
	--repository-error: red;
	/* markers for editor */
	--button-bg-cancel-mark: #C000002F; 
	--button-bg-accept-mark: #00C0002F;
	/* repository commit */
	--commit-outgoing: green;
	--commit-incoming: orange;
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
DockGtkConfiguration >> preferSystem [

	self reset.
	GRunLoop defer: [ self styleManager preferSystem ].
	self resetTheme.
	self settingAt: #theme put: #system
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
		
	self addCSSProviderFromString: self paletteStyle.
	self syntaxHighlightTheme: self defaultSyntaxHighlightThemeName.
	self styleScheme: self defaultStyleScheme
]

{ #category : 'private - settings' }
DockGtkConfiguration >> settingAt: aKey [

	^ self settings settingAt: #aKey
]

{ #category : 'private - settings' }
DockGtkConfiguration >> settingAt: aKey ifAbsent: aBlock [

	^ self settings 
		settingAt: #aKey
		ifAbsent: aBlock
]

{ #category : 'private - settings' }
DockGtkConfiguration >> settingAt: aKey ifPresent: aBlock [

	^ self settings 
		settingAt: aKey
		ifPresent: aBlock
]

{ #category : 'private - settings' }
DockGtkConfiguration >> settingAt: aKey put: aValue [

	^ self settings 
		settingAt: aKey
		put: aValue
]

{ #category : 'private' }
DockGtkConfiguration >> settings [

	^ settings
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
.stRow { margin: 1px; border-spacing: 3px; }
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
/* Editors */
.dockEditorLinked { border-width: 1px; border-style: solid; border-color: @accent_bg_color; }
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
.dockPlaygroundBindingsFlyingBrowser { min-width: 400px; min-height: 240px; }
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
.dockRepositories .dockRepositoryRow label.missing { color: var(--repository-error); }
.dockRepositories .dockRepositoryRow label.detached { color: var(--repository-detached); } 
.dockRepositories .dockRepositoryRow label.modified { color: var(--repository-modified); }
.dockRepositories .dockRepositoryRow label.error { color: var(--repository-error); }

/* search text */
/* this is a hack because for now I do not want to lose time on this */
.dockSearchPanel grid { margin: -12px -20px -12px -16px; padding: 0px; border-spacing: 0px; border: 0px; border-top-width: 0px;  border-spacing: 4px; } 
.dockSearchPanel .count { margin-right: 10px; }
.dockSearchPanel .buttonToggleSearch { border-radius: 0px; padding: 2px; margin-left: 4px; }

/* repository */

.dockRepositoryPatch { margin: 5px; padding: 5px; background-color: var(--card-bg-color); border-radius: 4px; }
.dockRepositoryPatch box.dockToolbarPanel { background-color: transparent; }
.dockRepositoryPatch box.dockToolbarPanel box { font-size: 1.0em; margin: 2px 2px 6px 2px; }
.dockRepositoryCommit label { margin-left: 5px; }
.dockRepositoryBranchRow label.head { font-weight: bold; }
.dockRepositoryRow .extra label.outgoing, .dockRepositoryBranchRow .extra label.outgoing { color: var(--commit-outgoing); }
.dockRepositoryRow .extra label.incoming, .dockRepositoryBranchRow .extra label.incoming{ color: var(--commit-incoming); }
.dockRepositoryCommitView label.outgoing { color: var(--commit-outgoing); }
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
	self settingAt: #styleScheme put: aString.
	self announceThemeChanged
]

{ #category : 'accessing' }
DockGtkConfiguration >> syntaxHighlightTheme [

	^ syntaxHighlightThemeName ifNil: [ 
		syntaxHighlightThemeName := self 
			settingAt: #syntaxHighlightTheme
			ifAbsent: [ self defaultSyntaxHighlightThemeName ] ]
]

{ #category : 'accessing - style' }
DockGtkConfiguration >> syntaxHighlightTheme: aName [

	super syntaxHighlightTheme: aName.
	self settingAt: #syntaxHighlightTheme put: aName. 
	self announceSyntaxHighlightThemeChanged
]

{ #category : 'private' }
DockGtkConfiguration >> themeChanged [

	self resetDefaultSyntaxHighlightForTheme.
	self announceThemeChanged.
	self announceSyntaxHighlightThemeChanged.
]
