Class {
	#name : #PvAliasedVSCodeIconProvider,
	#superclass : #PvVSCodeIconProvider,
	#traits : 'SgaTAliasIconTable',
	#classTraits : 'SgaTAliasIconTable classTrait',
	#category : #'Perspective-Icon'
}

{ #category : #accessing }
PvAliasedVSCodeIconProvider >> aliasFor: aName [

	^ self aliases
		at: aName asString
		ifAbsent: [ aName ]
]

{ #category : #accessing }
PvAliasedVSCodeIconProvider >> iconNamed: aName ifAbsent: aBlock [

	^ super 
		iconNamed: (self aliasFor: aName) 
		ifAbsent: [
			(Smalltalk at: #CollectUsedIcons ifAbsentPut: [ Set new ]) add: aName.
			aBlock value ]
]

{ #category : #initialization }
PvAliasedVSCodeIconProvider >> initialize [

	super initialize.
	self addAliasesFromPairs: { 				
		'add'.							'add'.					
		"#addFolder"
		'groupByMethod'. 			'extensions'.			"browser (extensions)"
		'library'. 					'library'.				"browser (system deps)"
		'class'. 						'symbol-class'.			"type"
		'classAbstract'. 			'symbol-class'.			"type"
		'method'. 					'symbol-method'.		"type"
		'openProject'. 				'folder-opened'.		"browser (open project)"
		"#overlayClass.
		#overlayMethod.
		#overlayTrait.
		#overlayVariable."
		'project'. 					'project'.				"browser (project/baseline)"
		'tag'.							'tag'.						"browser (packageTag)"
		"#unknownJdk."
		'view-more-symbolic'. 	'more'.
		"blank"
		"classAbstract"
		'glamorousGo'.				'run'.						"playground (go)"
		'glamorousMore'.			'file-submodule'.		"playground (pages)"
		'glamorousSaveToUrl'.		'cloud-upload'.			"playground (upload to the web)"
		'glamorousTable'. 			'table'.					"playground (bindings)"
		'package'.					'package'.				"browser-> package"
		'smallForward'.				'arrow-right'.
		'smallHierarchyBrowser'.	'type-hierarchy'.		"browser -> navigation hierarchy"
		'trait'.						'symbol-trait'.			"type"
		'workspace'.					'window'.					"playground"
		'announcement'.				'symbol-announcement'. "type"
		'arrowDown'.					'arrow-small-down'.	"browser-> overrides"
		'arrowUp'.					'arrow-small-up'.		"browser-> overriding"
		'flagIcon'.					'bookmark'.				"browser (to show there are flags)"
		'smallWindow'.				'symbol-window'.		"type (presenter...)" 
		'morph'.						'symbol-morph'.			"type"
		'exception'.					'symbol-event'.			"type"
		'variable'.					'symbol-variable'.		"type"
		'smallInspectIt'.			'eye'.						"inspector..."
		'string'.						'symbol-string'.		"type"
		'magnitude'.					'symbol-numeric'.		"type"
		'collection'.				'symbol-namespace'.	"type"
		'glamorousClose'. 			'close'.   				"inspector"
		'history'.					'history'. 				"playground"
		'smallObjects'.				'beaker'.  				"inspector"
		'glamorousRefresh'. 		'refresh'. 				"inspector"
		'smallSystemBrowser'. 	'browser'. 				"inspector"
		'referencesIcon'.			'type-hierarchy'.		"message browser"
		'smallDoIt'. 				'run'.						"code"
		'smallDebug'. 				'bug'.						"code"
		'smallPrintIt'. 			'blank'.					"code"
		'smallProfile'. 			'blank'.					"code"
	 }
	
]

{ #category : #utilities }
PvAliasedVSCodeIconProvider >> loadIcon: fileReference [

	^ (super loadIcon: fileReference) scaledIntoFormOfSize: 16
]
