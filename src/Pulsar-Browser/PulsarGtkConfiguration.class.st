Class {
	#name : 'PulsarGtkConfiguration',
	#superclass : 'StPharoGtkConfiguration',
	#instVars : [
		'settings',
		'styleManager',
		'announcer'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'private' }
PulsarGtkConfiguration >> announceSyntaxHighlightThemeChanged [

	self announcer announce: (PulsarSyntaxHighlightThemeChanged new
		newTheme: self syntaxHighlightTheme;
		yourself)
]

{ #category : 'events' }
PulsarGtkConfiguration >> announceThemeChanged [

	self announcer announce: (PulsarThemeChanged new 
		isDark: self isDarkTheme;
		yourself)
]

{ #category : 'private' }
PulsarGtkConfiguration >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'private - settings' }
PulsarGtkConfiguration >> applySettings [

	self settings theme 
		ifNotNil: [ :aValue | self applyTheme: aValue ].
	(self settings syntaxHighlightThemeFor: self isDarkTheme) 
		ifNotNil: [ :aValue | self applySyntaxHighlightTheme: aValue ].
	(self settings styleSchemeFor: self isDarkTheme) 
		ifNotNil: [ :aValue | self appplyStyleScheme: aValue ]		
]

{ #category : 'private - settings' }
PulsarGtkConfiguration >> applySyntaxHighlightTheme: aString [

	self syntaxHighlightTheme: aString
]

{ #category : 'private - settings' }
PulsarGtkConfiguration >> applyTheme: aSymbol [
	"this is a setting before anything... we do not refresh anything as this is the very initial thing to execute"
	| selector |

	selector := #preferSystem.
	aSymbol = #dark ifTrue: [ selector := #forceDark ].
	aSymbol = #light ifTrue: [ selector := #forceLight ].
	
	GRunLoop defer: [ self styleManager perform: selector ]
]

{ #category : 'private - settings' }
PulsarGtkConfiguration >> appplyStyleScheme: aString [

	self styleScheme: aString
]

{ #category : 'accessing' }
PulsarGtkConfiguration >> colorsForTestResult [

	^ self isDarkTheme
		ifTrue: [ self darkColorsForTestResult ]
		ifFalse: [ self lightColorsForTestResult ]
]

{ #category : 'configuring' }
PulsarGtkConfiguration >> configure: anApplication [

	self applicationClass: PanelApplication.
	settings := anApplication settings.
	super configure: anApplication
]

{ #category : 'configuring' }
PulsarGtkConfiguration >> configureGeneral: anApplication [
	
	"first to all, so I have settings available for the rest"
	settings := anApplication settings.
	
	super configureGeneral: anApplication.
	self addCSSProviderFromString: self style.
	
	self announcer
		when: PulsarThemeChanged send: #themeChanged: to: anApplication;
		when: PulsarSyntaxHighlightThemeChanged send: #syntaxHighlightThemeChanged: to: anApplication.
		
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
PulsarGtkConfiguration >> darkColorsForTestResult [

	^ SmallDictionary newFromPairs: {
		#passed. 	'LightGreen'.
		#failure. 	'DarkOrange'.
		#error.  	'Tomato' }
]

{ #category : 'accessing - style' }
PulsarGtkConfiguration >> darkPaletteStyle [

	^ '
/* testing */
@define-color test_passed 			LightGreen;
@define-color test_error 			Tomato;
@define-color test_failure 			DarkOrange;
/* repositories */
@define-color repository_modified 	LightGreen;
@define-color repository_detached 	DarkOrange;
@define-color repository_error 		Tomato;	
/* markers for editor */
@define-color button_bg_cancel_mark 	#FF00006F;
@define-color button_bg_accept_mark 	#00DF006F;
/* repository commit */
@define-color commit_outgoing 		LightGreen;
@define-color commit_incoming 		Yellow;
@define-color package_notloaded 		DarkGray;
@define-color repository_branch 		DarkGray;
/* pin */
@define-color pinned_bg_color		#1f232a;
/* commit */
@define-color commit_active_bg 		rgba(220, 130, 40, 0.26);
'
]

{ #category : 'private - defaults' }
PulsarGtkConfiguration >> defaultStyleScheme [

	^ self isDarkTheme
		ifTrue: [ self defaultStyleSchemeDark ]
		ifFalse: [ self defaultStyleSchemeLight ]
]

{ #category : 'private - defaults' }
PulsarGtkConfiguration >> defaultStyleSchemeDark [

	^ 'Adwaita-dark'
]

{ #category : 'private - defaults' }
PulsarGtkConfiguration >> defaultStyleSchemeLight [

	^ 'Adwaita'
]

{ #category : 'private - defaults' }
PulsarGtkConfiguration >> defaultSyntaxHighlightThemeName [

	^ self isDarkTheme
		ifTrue: [ self defaultSyntaxHighlightThemeNameDark ]
		ifFalse: [ self defaultSyntaxHighlightThemeNameLight ]
]

{ #category : 'private - defaults' }
PulsarGtkConfiguration >> defaultSyntaxHighlightThemeNameDark [
	
	^ 'CodeDark'
]

{ #category : 'private - defaults' }
PulsarGtkConfiguration >> defaultSyntaxHighlightThemeNameLight [
	
	^ 'CodeLight'
]

{ #category : 'accessing' }
PulsarGtkConfiguration >> forceDark [

	self reset.
	GRunLoop defer: [ self styleManager forceDark ].
	self resetTheme.
	self settings theme: #dark
]

{ #category : 'accessing' }
PulsarGtkConfiguration >> forceLight [

	self reset.
	GRunLoop defer: [ self styleManager forceLight ].
	self resetTheme.
	self settings theme: #light
]

{ #category : 'testing' }
PulsarGtkConfiguration >> isDarkTheme [
	
	^ GRunLoop defer: [ self styleManager isDark ]
]

{ #category : 'accessing' }
PulsarGtkConfiguration >> lightColorsForTestResult [

	^ SmallDictionary newFromPairs: {
		#passed. 	'Green'.
		#failure. 	'Orange'.
		#error.  	'Red' }
]

{ #category : 'accessing - style' }
PulsarGtkConfiguration >> lightPaletteStyle [

	^ '
/* testing */
@define-color test_passed 				green;
@define-color test_error 				red;
@define-color test_failure 				orange;
/* repositories */
@define-color repository_modified 		green;
@define-color repository_detached 		orange;
@define-color repository_error 			red;
/* markers for editor */
@define-color button_bg_cancel_mark 		#C000002F; 
@define-color button_bg_accept_mark 		#00C0002F;
/* repository commit */
@define-color commit_outgoing 			green;
@define-color commit_incoming 			orange;
@define-color package_notloaded 			#A0A0A0;
@define-color repository_branch 			#A0A0A0;
/* pin */
@define-color pinned_bg_color			#f3f6fb;
/* commit */
@define-color commit_active_bg 			rgba(255, 165, 80, 0.30);
'
]

{ #category : 'accessing - style' }
PulsarGtkConfiguration >> paletteStyle [

	^ self isDarkTheme
		ifTrue: [ self darkPaletteStyle ]
		ifFalse: [ self lightPaletteStyle ]
]

{ #category : 'accessing' }
PulsarGtkConfiguration >> preferSystem [

	self reset.
	GRunLoop defer: [ self styleManager preferSystem ].
	self resetTheme.
	self settings theme: #system
]

{ #category : 'configuring' }
PulsarGtkConfiguration >> reloadOnApplication: anApplication [ 

	^ self configure: anApplication
]

{ #category : 'private' }
PulsarGtkConfiguration >> resetDefaultSyntaxHighlightForTheme [

	syntaxHighlightThemeName := nil.
	styleScheme := nil
]

{ #category : 'private' }
PulsarGtkConfiguration >> resetTheme [
		
	self addCSSProviderFromString: self paletteStyle.
	self syntaxHighlightTheme: self defaultSyntaxHighlightThemeName.
	self styleScheme: self defaultStyleScheme
]

{ #category : 'private - settings' }
PulsarGtkConfiguration >> settings [

	^ settings
]

{ #category : 'accessing - style' }
PulsarGtkConfiguration >> style [

	^ ' 
checkbutton { padding: 0px; min-width: 0px; min-height: 0px; }
checkbutton check { min-width: 12px; min-height: 12px; margin: 0px; }
button.compact { min-width: 0px; min-height: 0px; padding: 0px; margin: 0px; }
button.compact image { min-width: 14px; min-height: 14px; -gtk-icon-size: 14px; }
treeexpander { border-spacing: 1px; }
treeexpander > expander { margin: 0px; min-width: 8px; min-height: 8px; }

popover label { color: unset; }
popover label.dim { color: LightSlateGrey; }
toast { border-radius: 4px; padding: 0px 8px; }
panelframeswitcher { margin: 2px; min-height: 20px; min-width: 20px; }
panelframeswitcher button { border: 1px; border-radius: 4px; box-shadow: none; }
panelframetabbar { min-height: 0px; padding: 0px; margin: 0px; }
panelframetabbar tabbar tabboxchild { border-radius: 0px; }
panelframetabbar tabbar tabboxchild tab { min-height: 0px; padding: 2px; border: 1px; border-radius: 4px; box-shadow: none; }
panelframetabbar tabbar tabboxchild tab:selected { background-color: alpha(@accent_bg_color, 0.85); color: @accent_fg_color; }
panelframetabbar tabbar widget.end-action  { min-height: 0px; padding: 0px; margin: 0px; }
paneldock listview { background-color: @window_bg_color; }
paneldock box.pulsarToolbarPanel { background-color: @window_bg_color; }
panelgrid listview { background-color: @view_bg_color; } /* reset central part so I can see clear */
paneldock panelframe popover listview { background-color: @view_bg_color; }
paneldock panelframe popover box.pulsarToolbarPanel { background-color: unset; }

.stList listview, 
.stTree listview { font-size: 0.9em; }
.stTree columnview listview row cell { margin: 0px; padding: 2px; }
.stTree columnview listview row cell box { border-spacing: 5px; }
.stRow { margin: 1px; border-spacing: 3px; }
.tinyFont {font-size: 0.7em; font-weight: normal; }
.searchBox { background-color: @popover_bg_color; }
.searchBox entry { margin: 2px; }
.link { padding: 0px; }
.cell-link { font-size: smaller; font-weight: normal; color: gray; min-width: 10px; }
.pvEditorScrollBar { min-height: 150px; }
.pvNavigation { min-width: 450px; min-height: 350px; padding: 5px; }
button.pvProtocol { font-weight: normal; }
.pvProtocolChooser { min-width: 250px; min-height: 280px; }
tab .tab-title label { font-size: 0.9em; }
.pulsarProjectView .modified { color: green; }

.pulsarProtocolRow label.virtual { font-style: italic; }
.pulsarProtocolRow label.unclassified { color: red; }
.pulsarProtocolRow label.undeclared { color: red; font-style: italic; }
.pulsarStack label.count { padding-right: 5px; }
.pulsarStackRow image.button:hover { background-color: alpha(currentColor, 0.12); }
.pulsarToolbar { margin: 0px; padding: 0px; }
/* Editors */
.pulsarEditorLinked { border-width: 1px; border-style: solid; border-color: @accent_bg_color; }
.pulsarDirtyMarker button { padding: 2px; }
.pulsarDirtyMarker .cancel { background-color: @button_bg_cancel_mark; }
.pulsarDirtyMarker .accept { background-color: @button_bg_accept_mark; }
.pulsarEditorBreadcrumb { font-size: 9pt; }
.pulsarEditorBreadcrumb label.separator { padding: 0px 5px 0px 5px; }
popover .pulsarPreviewEditor { min-width: 680px; min-height: 340px; }
.pulsarDialog, .pulsarFlyingBrowser { margin: 5px; border-spacing: 5px; }
box.pulsarDialog box { margin: 0px; } 

.pulsarSpotter { margin: 5px; border-spacing: 5px; min-width: 700px; }
.pulsarSpotter entry.search { margin: 15px 10px 5px 10px; }

.pulsarMessageFlyingBrowser { min-width: 720px; min-height: 460px; }
.pulsarInspectorFlyingBrowser { min-width: 680px; min-height: 440px; }
.pulsarHierarchyFlyingBrowser { min-width: 450px; min-height: 350px; }
.pulsarMethodHierarchyFlyingBrowser { min-width: 680px; min-height: 440px; }

.pulsarFlyingBrowser notebook tabs tab { padding: 2px; }
.pulsarFlyingBrowser notebook tabs tab label { font-size: 0.9em; }
.pulsarPopoverControlToolbar { margin: 0px; padding: 0px 0px 0px 10px; }
.pulsarDebuggerToolbar { background-color: @window_bg_color; }
.pulsarDebuggerToolbar .stToolbar { padding: 1px; }
.pulsarPlaygroundBindingsFlyingBrowser { min-width: 400px; min-height: 240px; }
/* Versions browser */
box.pulsarVersionsFlyingBrowser { min-width: 680px; min-height: 420px; }
box.pulsarVersionsFlyingBrowser panelstatusbar { background-color: transparent; } 
/* commit info */
box.commitInfo > * { margin-top: 5px; }
box.commitInfo { margin: 0px; padding: 0px; border-spacing: 0px; } 
box.commitInfo box.horizontal { border-spacing: 10px; }
box.commitInfo box.horizontal box.horizontal { border-spacing: 0px; padding: 0px; margin: 0px; }
box.commitInfo .author { font-weight: 500; letter-spacing: 0.01em; }
box.commitInfo textview { background-color: transparent;  }
box.commitInfo .separator { opacity: 0.8; }

.diffEditor box.commitInfo { padding: 10px;	}
.diffEditor box.commitInfo box { padding: 0px; }

/* generic pills */
.pill-commit {
  background-color: alpha(currentColor, 0.08);
  border-radius: 6px;
  padding: 2px 6px;
  font-size: 0.9em;
  transition: background-color 120ms ease, border-color 120ms ease;
}

.pill-commit-active {
  background-color: @commit_active_bg;
  border: 1px solid rgba(255, 140, 60, 0.35);
  border-radius: 6px;
  padding: 2px 6px;
  font-size: 0.9em;
}

/***
 * METHOD DECORATIONS 
 */
.pulsarMethodRow .trait, 
.pulsarProtocolRow .trait,
.pulsarSlotRow .trait { 
	font-style: italic;  
	text-decoration-line: underline;
}
.pulsarMethodRow .abstract {
	text-decoration-line: underline;
	text-decoration-style: double;
}
.pulsarMethodRow .extension { 
	font-style: italic; 
	text-decoration-line: underline;
	/* text-decoration-style: dotted; */ /*Currently not supported by gtk */
}
.pulsarMethodRow button.action {
	margin: 0px;
	padding: 0px;
	min-height: 16px;
	opacity: 0;
}
.pulsarMethodRow:hover button.action {
	opacity: 1;
}

.pulsarMethodRow .deprecated { 
	text-decoration-line: line-through;
}

/* .pulsarMethodRow .test-unknown { } */
.pulsarMethodRow .test-passed { color: @test_passed; }
.pulsarMethodRow .test-error { color: @test_error; }
.pulsarMethodRow .test-failure { color: @test_failure; }

.pulsarMethodProtocol { border-spacing: 3px; }
.pulsarMethodProtocol button { font-weight: normal; font-size: 9pt; }

/* Repositories (I can also have .notLoaded and .upToDate) */
.pulsarRepositories .pulsarRepositoryRow label.missing { color: @repository_error; }
.pulsarRepositories .pulsarRepositoryRow label.detached { color: @repository_detached; } 
.pulsarRepositories .pulsarRepositoryRow label.modified { color: @repository_modified; }
.pulsarRepositories .pulsarRepositoryRow label.error { color: @repository_error; }

/* search text */
/* this is a hack because for now I do not want to lose time on this */
.pulsarSearchPanel grid { margin: -12px -20px -12px -16px; padding: 0px; border-spacing: 0px; border: 0px; border-top-width: 0px;  border-spacing: 4px; } 
.pulsarSearchPanel .count { margin-right: 10px; }
.pulsarSearchPanel .buttonToggleSearch { border-radius: 0px; padding: 2px; margin-left: 4px; }

/* repository */
.pulsarRepositoryPatch { margin: 5px; padding: 5px; background-color: @card_bg_color; border-radius: 4px; }
.pulsarRepositoryPatch box.pulsarToolbarPanel { background-color: transparent; }
.pulsarRepositoryPatch box.pulsarToolbarPanel box { font-size: 0.9em; margin: 0px; }
.pulsarRepositoryCommit label { margin-left: 5px; }
.pulsarRepositoryBranchRow label.head { font-weight: bold; }
.pulsarRepositoryRow .extra label.outgoing, .pulsarRepositoryBranchRow .extra label.outgoing { color: @commit_outgoing; }
.pulsarRepositoryRow .extra label.incoming, .pulsarRepositoryBranchRow .extra label.incoming{ color: @commit_incoming; }
.pulsarRepositoryRow .extra label.tags,
.pulsarRepositoryRow .extra label.branch { font-style: italic; font-size: 0.8em; color: @repository_branch; }
.pulsarRepositoryCommit label.outgoing { color: @commit_outgoing; }
/* .pulsarRepositoryPackageRow label.loaded { } */
.pulsarRepositoryPackageRow label.notloaded { color: @package_notloaded; }
.diffEditor .pulsarToolbarPanel { padding: 5px; }

box.pulsarRepositoryCheckout box.checkoutStrategy {
	border-spacing: 10px;
	padding: 5px 10px;
}

/* llm */
.pulsarChatConsole vte-terminal { min-width: 200px; }

/* test case detail */
box.testCaseDetail { margin: 10px; }
box.testCaseDetail box { margin: 0px; }
box.testCaseDetail > * { margin-top: 4px; }
box.testCaseDetail box.horizontal { border-spacing: 6px; }
box.testCaseDetail .detailStatus { font-weight: 500; letter-spacing: 0.01em; }
box.testCaseDetail .detailInfo { font-size: 0.9em; color: alpha(currentColor, 0.75); }
box.testCaseDetail .detailDuration { font-size: 0.85em; color: alpha(currentColor, 0.55); }
'
]

{ #category : 'private' }
PulsarGtkConfiguration >> styleManager [

	styleManager isNullOrNil 
		ifTrue: [ styleManager := AdwStyleManager default ].
	
	^ styleManager
]

{ #category : 'accessing - style' }
PulsarGtkConfiguration >> styleScheme: aString [

	super styleScheme: aString.
	self isDarkTheme
		ifTrue: [ self settings styleSchemeDark: aString ]
		ifFalse: [ self settings styleSchemeLight: aString ].
	self announceThemeChanged
]

{ #category : 'accessing' }
PulsarGtkConfiguration >> syntaxHighlightTheme [

	^ syntaxHighlightThemeName ifNil: [
		syntaxHighlightThemeName := (self settings syntaxHighlightThemeFor: self isDarkTheme)
				ifNil: [ self defaultSyntaxHighlightThemeName ] ]
]

{ #category : 'accessing - style' }
PulsarGtkConfiguration >> syntaxHighlightTheme: aName [

	super syntaxHighlightTheme: aName.
	self isDarkTheme
		ifTrue: [ self settings syntaxHighlightThemeDark: aName ]
		ifFalse: [ self settings syntaxHighlightThemeLight: aName ].
	self announceSyntaxHighlightThemeChanged
]

{ #category : 'private' }
PulsarGtkConfiguration >> themeChanged [

	self resetDefaultSyntaxHighlightForTheme.
	self announceThemeChanged.
	self announceSyntaxHighlightThemeChanged.
]
