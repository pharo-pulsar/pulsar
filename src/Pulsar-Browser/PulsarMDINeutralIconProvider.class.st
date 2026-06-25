"
Provides material design icons from [Templarian](https://github.com/Templarian/MaterialDesign). 

This icons are stored as SVG in an accessinble place for the image and transformed on the fly using [pharo-resvg](https://github.com/pharo-cig/pharo/resvg). This means this provider can adapt itself to whatever the scale of icons will be required.

"
Class {
	#name : 'PulsarMDINeutralIconProvider',
	#superclass : 'SpLocationIconProvider',
	#instVars : [
		'application',
		'table',
		'mutex',
		'colorTable'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'utilities' }
PulsarMDINeutralIconProvider class >> syncIconTable [
	<script>
	"used to synchronize the icons from the full available repository to pulsar repo. 
	 this allow us to not needing to keep all icons in our sources (they are ~7500 or them)"
	| sourceDir destDir |
	
	sourceDir := '/home/esteban/dev/MaterialDesign-SVG/svg' asFileReference.
	destDir := '/home/esteban/dev/repo/pharo/Pulsar/resources/MaterialDesign/svg' asFileReference.

	self basicNew createTable do: [ :each |
		| source dest |
		source := (sourceDir / each second) withExtension: 'svg'.
		dest := destDir / source basename. 
		
		dest exists ifFalse: [
			source exists ifFalse: [ self error: 'File ', source fullName, ' does not exist.' ].
			source copyTo: dest.
			logger info: (source basename, ' syncd') ] ]
]

{ #category : 'accessing' }
PulsarMDINeutralIconProvider >> application [

	^ application
]

{ #category : 'accessing' }
PulsarMDINeutralIconProvider >> application: anApplication [

	application := anApplication
]

{ #category : 'private' }
PulsarMDINeutralIconProvider >> colorFor: iconName forceNeutral: forceBoolean [

	^ self isDarkTheme
		ifTrue: [ self darkColorFor: iconName forceNeutral: forceBoolean ]
		ifFalse: [ self lightColorFor: iconName forceNeutral: forceBoolean ]
]

{ #category : 'private' }
PulsarMDINeutralIconProvider >> colorFor: iconName themePosition: aNumber forceNeutral: forceBoolean [
	"1 is the position of light colors
	 2 is the position of dark colors 
	 (see #createTable)"
	
	^ forceBoolean 
		ifTrue: [ self neutralColors at: aNumber ]
		ifFalse: [ (colorTable at: iconName ifAbsent: [ self neutralColors ]) at: aNumber ]
]

{ #category : 'initialization' }
PulsarMDINeutralIconProvider >> createTable [
	"a list of arrays internal-name, material-name, light-color, dark-color. 
	 light and dark colors can be missing (because neutral colors are taken elsewhere)"
	 <script: 'self syncIconTable'>

	^ #(
		"Metamodel / code structure"
		('class'                  'alpha-c-box'           		'#1c71d8'  	'#62a0ea')
		('classAbstract'          'alpha-c-box'           		'#1c71d8'  	'#62a0ea')
		('trait'                  'alpha-t-box'           		'#813d9c'  	'#c061cb')
		('method'                 'alpha-m-box'           		'#26a269'  	'#57e389')
		('variable'               'variable'  					'#e66100'  	'#ffa348')
		('package'                'cube-outline'               	'#e66100'  	'#ffa348')
		('protocolExtension'      'cube-scan'               		'#e66100'  	'#ffa348')
		('collection'             'code-braces'           		'#813d9c'  	'#c061cb')
		('morph'                  'shape-outline'                	'#9141ac'  	'#dc8add')
		('string'                 'pound'                   		'#865e3c'  	'#cdab8f')
		('magnitude'              'numeric'                     	'#1c71d8'  	'#62a0ea')
		('exception'              'lightning-bolt-outline'      	'#e5a50a'  	'#f8e45c')
		('announcement'           'message-outline'  				'#0891b2' 	'#cffafe')
		('project'                'folder-outline'				'#3b4a77' 	'#b8c6ee')
		('project-volatile' 	  	  'folder-outline'				'#9db7e8' 	'#c6a0f6')
		('systemEnvironment'      'library-outline' 				'#3446a3' 	'#aebcff')
		('projects'                'folder-outline')
		('error' 				  'alert-circle-outline' 		'#cf222e' 	'#f85149')
		('warning'				  'alert-outline' 				'#b86e00' 	'#d9902f')
		('info'				  	  'information-outline' 			'#0969da' 	'#58a6ff')

		"Run / debug"
		('glamorousGo'            'play-outline'                  '#26a269'  '#57e389')
		('smallDoIt'              'play-outline'                  '#26a269'  '#57e389')
		('play'                   'play-outline'                  '#26a269'  '#57e389')
		('pause'                  'pause'                         '#e5a50a'  '#f8e45c')
		('stop'                   'stop'                          '#c01c28'  '#f66151')
		('smallDebug'             'bug-outline'                   '#c01c28'  '#f66151')
		('debuggerProceed'        'play-outline'                  '#26a269'  '#57e389')
		('debuggerRestart'        'restart'                       '#1c71d8'  '#62a0ea')
		('debuggerStepInto'       'debug-step-into'               '#1c71d8'  '#62a0ea')
		('debuggerStepOver'       'debug-step-over'               '#1c71d8'  '#62a0ea')
		('debuggerStepThrough'    'debug-step-through'            '#1c71d8'  '#62a0ea')
		('debuggerReturn'         'debug-step-out'                '#1c71d8'  '#62a0ea')
		('debuggerRunToSelection' 'debug-step-into'               '#1c71d8'  	'#62a0ea')
		('breakpoint' 			  'record-circle-outline' 		 '#b42318'	'#c75f5f')
		('context'				  'layers-triple-outline')

		"Tests"
		('run-test'               'play'                          '#26a269'  '#57e389')
		('run-test-passed'        'play-circle-outline'           '#26a269'  '#57e389')
		('run-test-failure'       'pause-circle-outline'          '#e5a50a'  '#f8e45c')
		('run-test-error'         'stop-circle-outline'           '#c01c28'  '#f66151')

		"Severity / warnings"
		('protocolVirtualWarning' 'alert-outline'                 '#e66100'  '#ffa348')
		('priority'               'fire'                          '#c01c28'  '#f66151')

		"Destructive / confirm"
		('add'                    'plus'                          "'#26a269'  '#57e389'")
		('accept'                 'check'                         '#26a269'  '#57e389')
		('highlight-all'          'check-all'                     '#26a269'  '#57e389')
		('smallDelete'            'trash-can-outline'             '#c01c28'  '#f66151')
		('delete'                 'trash-can-outline'             '#c01c28'  '#f66151')

		"VCS"
		('repositories'           'source-repository'             '#813d9c'  '#c061cb')
		('commit'                 'check'                         '#26a269'  '#57e389')
		('checkout-branch'        'source-branch-sync'            '#813d9c'  '#c061cb')
		('branch'                 'source-fork'                   '#813d9c'  '#c061cb')
		('merge'                  'source-merge'                  '#813d9c'  '#c061cb')
		('pull'                   'tray-arrow-down'               '#813d9c'  '#c061cb')
		('push'                   'tray-arrow-up'                 '#813d9c'  '#c061cb')
		('fetch'                  'arrow-down-right'    			 '#1c71d8'  '#62a0ea')
		('checkout'               'check'                         '#26a269'  '#57e389')
		('changeAdd'              'plus'                          '#26a269'  '#57e389')
		('changeRemove'           'minus'                         '#c01c28'  '#f66151')
		('changeUpdate' 		      'plus-minus-variant'			 '#813d9c' '#c061cb')
		('repository'			  'archive-outline')
		('stored-code'			  'snowflake'				 	 '#b0bec5'  '#78909c')
		('git'					  'git')
		('compare-branch'		  'compare')
		('lock'					  'lock')
		('unlock'				  'lock-open-variant')
		('dirtyProject'			  'source-commit-local')
		('remotes'			  	  'cloud-outline')
		('branches'				  'source-branch')
		('commits'				  'source-commit')
		('packages'				  'cube-outline')
		('changes'				  'file-code-outline')
		('diff'					  'file-compare')
		
		"Inspection / metamodel introspection"
		('smallInspectIt'      	 'eye-outline'             		'#0f766e' '#67e8f9')
		('inspector'           	 'eye-outline'             		'#0f766e' '#67e8f9')
		('smallProfile'        	 'eye-plus-outline'        		'#0f766e' '#67e8f9')
		('smallSystemBrowser'  	 'view-list-outline'             '#0f766e' '#67e8f9')
		('messageBrowser'      	 'phone-outline'                 '#0f766e' '#67e8f9')
		('smallWindow'            'application-outline' 			'#0f766e' '#67e8f9')
		('senders'             	 'phone-incoming-outline'  		'#0f766e' '#67e8f9')
		('implementors'           'phone-outgoing-outline'  		'#0f766e' '#67e8f9')
		('hierarchy'              'file-tree-outline'             '#0f766e' '#67e8f9')
		('smallHierarchyBrowser'  'file-tree-outline'             '#0f766e' '#67e8f9')
		('references'             'file-tree-outline'             '#0f766e' '#67e8f9')
		('browse'             	  'view-list-outline'  			'#0f766e' '#67e8f9')
		('pharo'					  'lighthouse'					'#0f766e' '#67e8f9')

		"Files / project / data UI"
		('open'                   'folder-open-outline')
		('load'                   'folder-open-outline')
		('openProject'            'folder-open-outline')
		('library'                'library-outline')
		('tag'                    'tag-outline')
		('glamorousTable'         'table')
		('glamorousSaveToUrl'     'cloud-upload-outline')
		('smallPrintIt'           'file-outline')
		('history'                'history')
		('overview'               'map-outline')
		('graph'                  'graph')
		('versions'               'animation-outline')
		('copy'					 'content-copy')
		('paste'					 'content-paste')
		('cut'					 'content-cut')
		('copy-to-clipboard'		 'clipboard-check-outline')

		"Navigation / menus / arrows"
		('view-more-symbolic'     'dots-horizontal')
		('menu'                   'dots-vertical')
		('smallForward'           'arrow-right')
		('arrowDown'              'arrow-down')
		('arrowUp'                'arrow-up')
		('up'                     'arrow-up')
		('down'                   'arrow-down')
		('chevron-right'          'chevron-right')
		('chevron-left'           'chevron-left')
		('chevron-up'          	  'chevron-up')
		('chevron-down'           'chevron-down')
		('search-forward'         'arrow-down')
		('search-backward'        'arrow-up')
		('firstActivationTime'    'account-plus-outline')
		('lastActivationTime'     'account-eye-outline')
		('sort'					  'sort')
		('pin'					  'pin')
		('dirty'					  'circle-medium')
		('flip-side'				  'swap-horizontal')
		('fileManager'			  'folder-outline')

		"Panels / layout / windows"
		('panel-left'             'dock-left')
		('panel-top'              'dock-top')
		('panel-right'            'dock-right')
		('panel-bottom'           'dock-bottom')
		('editorStack'            'view-grid-outline')

		"Search / filter widgets"
		('search'                 'magnify')
		('whole-word'             'format-letter-matches')
		('case-sensitive'         'case-sensitive-alt')
		('regex'                  'regex')
		('link'                   'link-variant')

		"Refresh / background activity"
		('refresh'                'refresh')
		('glamorousRefresh'       'refresh')
		('autoReload'             'broadcast')
		('autoUpdate'             'radio-tower')

		"Workspace / tools / misc UI"
		('workspace'              'flask-outline')
		('smallObjects'           'flask-outline')
		('groupByMethod'          'puzzle-outline')
		('stack'                  'layers-outline')
		('refactor'               'wrench-outline')
		('repair'                 'wrench-outline')
		('protocolPrivate'        'lock-outline')
		('protocolProtected'      'lock-outline')
		('protocolAll'            'pulse')
		('protocolVirtual'        'pulse')
		('flagIcon'               'bookmark-outline')
		('flag'                   'bookmark-outline' 				'#9a6700' '#f0b429')
		('critiques'              'bell-outline')
		('closeAll'               'close-box-multiple-outline')
		('close'                  'close')
		('glamorousClose'         'close')
		('cancel'                 'close')
		('variables'              'variable')
		('systemRepository'		  'archive-cog-outline')

		"History / undo / redo / save"
		('smallUndo'              'undo-variant')
		('smallRedo'              'redo')
		('undo'                   'undo')
		('redo'                   'redo')
		('discard'                'undo-variant')
		('smallSave'              'content-save')

		"Transcript"
		('transcript'             	'console')
		
		"LLM"
		('chat'			 			'chat-outline')
		('chat-connect'			 	'server-network-outline')
		
		"Files"
		('file'					'file-outline' 				'#b86e00' '#d9902f')
		('folder'				'folder-outline' 			'#b86e00' '#d9902f')
		('addFolder'				'folder-plus-outline')
		('addFile'				'file-plus-outline')
		('console'			    'console')
	)
]

{ #category : 'private' }
PulsarMDINeutralIconProvider >> darkColorFor: iconName forceNeutral: forceBoolean [
	
	^ self 
		colorFor: iconName 
		themePosition: 2 "the position of dark colors (see #createTable)"
		forceNeutral: forceBoolean
]

{ #category : 'accessing' }
PulsarMDINeutralIconProvider >> iconNamed: aName ifAbsent: aBlock [

	^ super 
		iconNamed: aName
		ifAbsent: [
			(Smalltalk 
				at: #CollectUsedIcons ifAbsentPut: [ Set new ]) 
				add: aName.
			aBlock value ]
]

{ #category : 'initialization' }
PulsarMDINeutralIconProvider >> initialize [

	super initialize.
	self initializeTable
]

{ #category : 'initialization' }
PulsarMDINeutralIconProvider >> initializeTable [
	
	table := Dictionary new.
	colorTable := Dictionary new.
	self createTable do: [ :each |
		table at: each first put: each second.
		each size > 2 ifTrue: [
			colorTable at: each first put: (each allButFirst: 2) ] ]
]

{ #category : 'testing' }
PulsarMDINeutralIconProvider >> isDarkTheme [

	^ self application configuration isDarkTheme
]

{ #category : 'private' }
PulsarMDINeutralIconProvider >> lightColorFor: iconName forceNeutral: forceBoolean [
	
	^ self 
		colorFor: iconName 
		themePosition: 1 "the position of light colors (see #createTable)"
		forceNeutral: forceBoolean
]

{ #category : 'utilities' }
PulsarMDINeutralIconProvider >> loadIcon: svgReference tint: colorHexString [
	| rawContents contents |
	
	rawContents := svgReference contents substrings: '>'.
	contents := String streamContents: [ :stream |
		stream << rawContents first << '>'; cr.
		stream << ('<style>
* { fill: ', colorHexString, ' !important; }
</style>').
	rawContents allButFirstDo: [ :each | 
		each trimBoth ifNotEmpty: [ 
			stream << each << '>' ] ] ].

	^ GRunLoop defer: [ 
		"Material design icons have 24x24 default size. 
		 here I can multiply for the scale, but it feels better keeping them in default 
		 size and let gtk4 do the scale work."
		LibRsvg
			renderFromString: contents
			size: 24@24 ]
]

{ #category : 'utilities' }
PulsarMDINeutralIconProvider >> loadIconNamed: aName [
	| iconName cleanName forceNeutral |

	(aName endsWith: '.neutral') 
		ifTrue: [
			cleanName := aName allButLast: 8.
			forceNeutral := true ]
		ifFalse: [
			cleanName := aName.
			forceNeutral := false ].
	
	iconName := table at: cleanName ifAbsent: [ ^ nil ].	

	self locations do: [ :each | 
		| ref |	
		ref := (each / iconName) withExtension: 'svg'.
		ref exists ifTrue: [
			^ self loadIcon: ref tint: (self colorFor: cleanName forceNeutral: forceNeutral) ] ].
	
	^ nil
]

{ #category : 'accessing' }
PulsarMDINeutralIconProvider >> mutex [

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'utilities' }
PulsarMDINeutralIconProvider >> neutralColors [
	"light, dark"

	^ #('#3d3846' '#deddda')
]
