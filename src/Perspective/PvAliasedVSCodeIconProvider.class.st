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
		"#addFolder"
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
		'smallHierarchyBrowser'.		'type-hierarchy'.		"browser -> navigation hierarchy"
		'trait'.						'symbol-trait'.			"type"
		'workspace'.					'lightbulb'. 			"'beaker'."	"playground"
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
		'string'.					'symbol-string'.			"type"
		'magnitude'.					'symbol-numeric'.		"type"
		'collection'.				'symbol-namespace'.		"type"
		'glamorousClose'. 			'close'.   				"inspector"
		'history'.					'history'. 				"playground"
		'smallDelete'. 				'trash'.					"playground..."
		'smallObjects'.				'beaker'.  				"inspector"
		'glamorousRefresh'. 			'refresh'. 				"inspector"
		'smallSystemBrowser'. 		'browser'. 				"inspector"
		'messageBrowser'. 			'browser'. 
		'referencesIcon'.			'type-hierarchy'.		"message browser"
		'smallDoIt'. 				'run'.					"code"
		'smallDebug'. 				'bug'.					"code"
		'smallPrintIt'. 				'blank'.					"code"
		'smallProfile'. 				'watch'.					"code"
		'menu'. 		   	       		'more'.    "menu button"
		'pause'. 					'debug-pause'.
		'priority'.					'flame'.
		'autoUpdate'.				'radio-tower'.
		"protocols"
		'protocolPrivate'. 	   		'lock-small'. "blocked"
		'protocolProtected'.     	'lock-small'. "blocked"
		'protocolExtension'.     	'package'. "symbol-variable"
		'protocolAll'.       	 	'pulse'.
		'protocolVirtual'.       	'pulse'. "radio-tower"
		'protocolVirtualWarning'. 	'warning'.
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
