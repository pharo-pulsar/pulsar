Class {
	#name : 'PvAliasedVSCodeIconProvider',
	#superclass : 'PvVSCodeIconProvider',
	#traits : 'SgaTAliasIconTable',
	#classTraits : 'SgaTAliasIconTable classTrait',
	#category : 'Perspective-Icon',
	#package : 'Perspective',
	#tag : 'Icon'
}

{ #category : 'accessing' }
PvAliasedVSCodeIconProvider >> aliasFor: aName [

	^ self aliases
		at: aName asString
		ifAbsent: [ aName ]
]

{ #category : 'accessing' }
PvAliasedVSCodeIconProvider >> iconNamed: aName ifAbsent: aBlock [

	^ super 
		iconNamed: (self aliasFor: aName) 
		ifAbsent: [
			(Smalltalk at: #CollectUsedIcons ifAbsentPut: [ Set new ]) add: aName.
			aBlock value ]
]

{ #category : 'initialization' }
PvAliasedVSCodeIconProvider >> initialize [

	super initialize.
	self addAliasesFromPairs: {
		'add'.						'add'.	
		'closeAll'.					'close-all'.
		'load'. 						'folder-opened'.
		'groupByMethod'. 			'extensions'.			"browser (extensions)"
		'library'.					'library'.				"browser (system deps)"
		'class'.						'symbol-class'.			"type"
		'classAbstract'.				'symbol-class'.			"type"
		'method'. 					'symbol-method'.			"type"
		'openProject'. 				'folder-opened'.			"browser (open project)"
		"#overlayClass.
		#overlayMethod.
		#overlayTrait.
		#overlayVariable."
		'project'. 					'project'.				"browser (project/baseline)"
		'tag'.						'tag'.					"browser (packageTag)"
		"#unknownJdk."
		'view-more-symbolic'. 		'more'.
		"blank"
		"classAbstract"
		'glamorousGo'.				'run'.					"playground (go)"
		'glamorousMore'.				'file-submodule'.		"playground (pages)"
		'glamorousSaveToUrl'.		'cloud-upload'.			"playground (upload to the web)"
		'glamorousTable'. 			'table'.					"playground (bindings)"
		'package'.					'package'.				"browser-> package"
		'smallForward'.				'arrow-right'.
		'hierarchy'.					'type-hierarchy'.		"browser -> navigation hierarchy"
		'trait'.						'symbol-trait'.			"type"
		'workspace'.					'beaker'. 				"'lightbulb'."	"playground"
		'transcript'. 		 		'terminal'.
		'announcement'.				'symbol-announcement'. 	"type"
		'arrowDown'.					'arrow-small-down'.		"browser-> overrides"
		'arrowUp'.					'arrow-small-up'.		"browser-> overriding"
		'flagIcon'.					'bookmark'.				"browser (to show there are flags)"
		'smallWindow'.				'symbol-window'.			"type (presenter...)" 
		'morph'.						'symbol-morph'.			"type"
		'exception'.					'symbol-event'.			"type"
		'variable'.					'symbol-variable'.		"type"
		'smallInspectIt'.			'eye'.					"inspector..."
		'inspector'. 				'eye'. 
		'senders'.					'call-incoming'.			"message browser - senders"
		'string'.					'symbol-string'.			"type"
		'magnitude'.					'symbol-numeric'.		"type"
		'collection'.				'symbol-namespace'.		"type"
		'glamorousClose'. 			'close'.   				"inspector"
		'history'.					'history'. 				"playground"
		'smallDelete'. 				'trash'.					"playground..."
		'delete'	.					'trash'.
		'smallObjects'.				'beaker'.  				"inspector"
		'glamorousRefresh'. 			'refresh'. 				"inspector"
		'smallSystemBrowser'. 		'browser'. 				"inspector"
		'messageBrowser'. 			'browser'. 
		'referencesIcon'.			'type-hierarchy'.		"message browser"
		'smallDoIt'. 				'run'.					"code"
		'smallDebug'. 				'bug'.					"code"
		'smallPrintIt'. 				'blank'.					"code"
		'smallProfile'. 				'watch'.					"code"
		'smallUndo'.					'discard'.
		'smallRedo'. 				'redo'.
		'smallSave'.					'save'.
		'undo'. 						'undo'.
		'redo'. 						'redo'.
		'menu'. 		   	       		'kebab-vertical'."'more', 'menu'"  "menu button"
		'pause'. 					'debug-pause'.
		'priority'.					'flame'.
		'autoUpdate'.				'radio-tower'.
		'stop'.						'debug-stop'.
		'pause'.						'debug-pause'.
		'play'. 						'debug-continue'.
		'up'. 						'arrow-up'.
		'down'.						'arrow-down'.
		'refresh'. 					'refresh'.
		'autoReload'. 				'broadcast'.
		"protocols"
		'protocolPrivate'. 	   		'lock-small'. "blocked"
		'protocolProtected'.     	'lock-small'. "blocked"
		'protocolExtension'.     	'package'. "symbol-variable"
		'protocolAll'.       	 	'pulse'.
		'protocolVirtual'.       	'pulse'. "radio-tower"
		'protocolVirtualWarning'. 	'warning'.
		"debugger"
		'debuggerProceed'. 			'debug-continue'.
		'debuggerStepInto'. 			'debug-step-into'.
		'debuggerStepOver'. 			'debug-step-over'.
		'debuggerStepThrough'. 		'debug-step-through'.
		'debuggerRestart'. 			'debug-restart'.
		'debuggerReturn'. 			'debug-step-out'.
		'debuggerRunToSelection'. 	'debug-runtoselection'.
		"dialogs"
		'accept'.					'check'.
		'cancel'.					'close'.
		"testing"
		'run-test'. 					'play'.
		'run-test-passed'. 			'play-green'.
		'run-test-failure'. 			'play-yellow'.
		'run-test-error'. 			'play-red'.
		'editorStack'.				'multiple-windows'.
		"versions"
		'changeAdd'.					'add'.
		'changeRemove'.				'remove'.
		'changeUpdate'.				'remote'. "not good"
		"same name (just to keep track of them)"
		'search'.					'search'.
		"panels"
		'panel-left'.				'layout-sidebar-left'.
		'panel-top'.					'layout-panel-top'.
		'panel-right'.				'layout-sidebar-right'.
		'panel-bottom'.				'layout-panel'.
		"search text"
		'search-forward'.			'arrow-down'.
		'search-backward'.			'arrow-up'.
		'highlight-all'.				'check-all'.
		"placed here as documentation:"
		"'whole-word'.				'whole-word'.
		'case-sensitive'. 			'case-sensitive'.
		'regex'.						'regex'.
		'chevron-right'. 			'chevron-right'.
		'chevron-down'.				'chevron-down'.
		'versions'.					'versions'."
		'variables'.					'symbol-key'.
		"'link'.						'link'"
		'flag'.						'bookmark'.
	 }
]

{ #category : 'utilities' }
PvAliasedVSCodeIconProvider >> loadIcon: fileReference [
	| icon |

	icon := super loadIcon: fileReference.
	"Overlays are smaller, but we do not want bigger icons"
	^ icon width > 16
		ifTrue: [ icon scaledIntoFormOfSize: 16 ]
		ifFalse: [ icon ]
]
