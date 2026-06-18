"
A model representing an arbitrary text file opened for editing in Pulsar.

It wraps a FileReference as its entity and provides source code access, file writing, and editor class resolution for the file editor tool.
"
Class {
	#name : 'PulsarFileModel',
	#superclass : 'PvBaseModel',
	#classVars : [
		'LanguagesByExtension',
		'LanguagesByName',
		'NameBasedIcons'
	],
	#category : 'Pulsar-Tool-FileEditor-Model',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Model'
}

{ #category : 'private' }
PulsarFileModel class >> extensionIconPairs [

	^ #( 
		'4th' 		'forth' 
		'abnf' 		'abnf' 
		'adb' 		'ada' 
		'adoc' 		'asciidoc' 
		'ads' 		'ada' 
		'am' 		'automake' 
		'as' 		'actionscript'
		'asciidoc' 	'asciidoc' 
		'asp' 		'asp' 
		'astro' 		'astro' 
		'awk' 		'awk' 
		'bat' 		'dosbatch' 
		'bib' 		'bibtex'
		'boo' 		'boo' 
		'bsv' 		'bluespec' 
		'c' 			'c' 
		'cbl' 		'cobol' 
		'cfg' 		'ini' 
		'cg' 		'cg' 
		'cl' 		'opencl' 
		'cls' 		'latex' 
		'cmd' 		'dosbatch' 
		'cob' 		'cobol' 
		'comp' 		'glsl' 
		'cpp' 		'cpp' 
		'cs' 		'c-sharp' 
		'css' 		'css' 
		'csv' 		'csv' 
		'cu' 		'cuda' 
		'cuh' 		'cuda' 
		'd' 			'd' 
		'dart' 		'dart' 
		'def' 		'def' 
		'desktop' 	'desktop' 
		'diff' 		'diff' 
		'dot' 		'dot' 
		'dpatch' 	'dpatch' 
		'dtd' 		'dtd' 
		'dtl' 		'dtl' 
		'e' 			'eiffel' 
		'erb' 		'erb' 
		'erl' 		'erlang'
		'ex' 		'elixir' 
		'exs' 		'elixir' 
		'f03' 		'fortran' 
		'f90' 		'fortran' 
		'f95' 		'fortran' 
		'fcl' 		'fcl' 
		'fish' 		'fish' 
		'fo' 		'xslt' 
		'frag' 		'glsl' 
		'fs' 		'fsharp' 
		'fsi' 		'fsharp' 
		'fsx' 		'fsharp' 
		'fth' 		'forth'
		'ftl' 		'ftl' 
		'g' 			'gap' 
		'gd' 		'gdscript' 
		'geom' 		'glsl' 
		'gi' 		'gap' 
		'glsl' 		'glsl' 
		'go' 		'go' 
		'gradle' 	'gradle' 
		'groovy' 	'groovy' 
		'gs' 		'genie' 
		'gv' 		'dot' 
		'gvy' 		'groovy' 
		'h' 			'c' 
		'hh' 		'cpphdr' 
		'hpp' 		'cpphdr' 
		'hrl' 		'erlang' 
		'hs' 		'haskell' 
		'html' 		'html' 
		'hx' 		'haxe' 
		'hxx' 		'cpphdr' 
		'idl' 		'idl' 
		'ijm' 		'imagej' 
		'ini' 		'ini' 
		'jade' 		'jade' 
		'java' 		'java' 
		'jl' 		'julia' 
		'js' 		'javascript' 
		'json' 		'json' 
		'jsx' 		'jsx' 
		'kt' 		'kotlin' 
		'l' 			'lex' 
		'lean' 		'lean' 
		'less' 		'less' 
		'lex' 		'lex' 
		'lgt' 		'logtalk'
		'lhs' 		'haskell-literate' 
		'lisp' 		'commonlisp' 
		'll' 		'llvm' 
		'logtalk' 	'logtalk' 
		'lsp' 		'commonlisp'
		'lua' 		'lua' 
		'm' 			'objc' "it could be matlab too"
		'm4' 		'm4' 
		'mac' 		'maxima' 
		'max' 		'maxima' 
		'md' 		'markdown' 
		'ml' 		'ocaml'
		'mli' 		'ocaml' 
		'mo' 		'modelica' 
		'mxml' 		'mxml' 
		'n' 			'nemerle' 
		'nix' 		'nix' 
		'nrx' 		'netrexx' 
		'nsh' 		'nsis'
		'nsi' 		'nsis' 
		'ocl' 		'ocl' 
		'ooc' 		'ooc' 
		'opal' 		'opal' 
		'pas' 		'pascal' 
		'patch' 		'diff' 
		'pc' 		'pkgconfig'
		'php' 		'php' 
		'pig' 		'pig' 
		'pl' 		'perl' 
		'pm' 		'perl' 
		'po' 		'gettext-translation' 
		'pot' 		'gettext-translation'
		'pp' 		'puppet' 
		'pro' 		'prolog' 
		'proto' 		'proto' 
		'ps1' 		'powershell' 
		'psm1' 		'powershell' 
		'py' 		'python'
		'r' 			'r' 
		'rb' 		'ruby' 
		're' 		'reasonml' 
		'rei' 		'reasonml' 
		'rq' 		'sparql' 
		'rs' 		'rust' 
		'rst' 		'rst' 
		'scala' 		'scala' 
		'sce' 		'scilab' 
		'sci' 		'scilab' 
		'scm' 		'scheme' 
		'scss' 		'scss' 
		'sh' 		'sh' 
		'sml' 		'sml' 
		'sol' 		'solidity' 
		'sparql' 	'sparql' 
		'spec' 		'rpmspec' 
		'sql' 		'sql' 
		'ss' 		'scheme' 
		'st' 		'smalltalk'
		'sty' 		'latex' 
		'sv' 		'systemverilog' 
		'svh' 		'systemverilog'
		'svg'		'xml'
		'swift' 		'swift' 
		't2t' 		't2t' 
		'tcl' 		'tcl'
		'tera' 		'tera' 
		'tesc' 		'glsl' 
		'tese' 		'glsl' 
		'tex' 		'latex' 
		'texi' 		'texinfo' 
		'texinfo' 	'texinfo'
		'tf' 		'terraform' 
		'tfvars' 	'terraform' 
		'thrift' 	'thrift' 
		'toml' 		'toml' 
		'ts' 		'typescript'
		'tsx' 		'typescript' 
		'twig' 		'twig' 
		'v' 			'verilog' 
		'vala' 		'vala' 
		'vapi' 		'vala' 
		'vb' 		'vbnet' 
		'vert' 		'glsl' 
		'vhd' 		'vhdl' 
		'vhdl' 		'vhdl' 
		'wren' 		'wren' 
		'xml' 		'xml' 
		'xsl' 		'xslt' 
		'xslt' 		'xslt' 
		'y' 			'yacc'
		'yaml' 		'yaml' 
		'yar' 		'yara' 
		'yara' 		'yara' 
		'yml' 		'yaml' 
		'yy' 		'yacc' 
		'zig' 		'zig' 
	)
]

{ #category : 'accessing' }
PulsarFileModel class >> guessLanguageOfFile: aFileReference [

	^ (self languageForName: aFileReference basename) ifNil: [
		  aFileReference extension 
		  	ifNotEmpty: [ :ext | self languageForExtension: ext asLowercase ]
		  	ifEmpty: [ nil ] ]
]

{ #category : 'accessing' }
PulsarFileModel class >> languageByNamePairs [

	^ { 
		'CHANGELOG'. 			'changelog'. 
		'CHANGES'. 				'changelog'. 
		'CMakeLists.txt'. 		'cmake'. 
		'Dockerfile'. 			'docker'.
		'GNUmakefile'. 			'makefile'. 
		'Makefile'. 				'makefile'. 
		'meson.build'. 			'meson'. 
		'NEWS'. 					'changelog'.
		'todo.txt'. 				'todotxt'. 
		'.editorconfig'. 		'editorconfig'. 
		'.eslintrc.js'. 			'eslint'. 
		'.eslintrc.cjs'. 		'eslint'. 
		'.eslintrc.yaml'. 		'eslint'. 
		'.eslintrc.yml'. 		'eslint'. 
		'.eslintrc.json'. 		'eslint'. 
		'.eslintrc'. 			'eslint'. 
		'.eslintignore'. 		'eslint'. 
		'.prettierrc'. 			'prettier'. 
		'.prettierrc.js'. 		'prettier'. 
		'.prettierrc.json'. 		'prettier'. 
		'.prettierrc.yaml'. 		'prettier'. 
		'.prettierrc.yml'. 		'prettier'. 
		'.prettierrc.toml'. 		'prettier'. 
		'.prettierignore'. 		'prettier'. 
		'.gitignore'. 			'git'. 
		'.gitattributes'. 		'git'. 
		'.gitmodules'. 			'git'. 
		'.babelrc'. 				'babel'. 
		'.babelrc.js'. 			'babel'. 
		'.babelrc.json'. 		'babel'. 
		'babel.config.js'. 		'babel'. 
		'babel.config.json'. 	'babel'. 
		'nginx.conf'. 			'nginx'. 
		'package.json'. 			'npm'. 
		'yarn.lock'. 			'yarn'. 
		'pnpm-lock.yaml'. 		'pnpm'. 
		'composer.json'. 		'composer'. 
		'.travis.yml'. 			'travis'. 
		'.gitlab-ci.yml'. 		'gitlab'. 
		'Jenkinsfile'. 			'jenkins'. 
		'.circleci'. 			'circleci'. 
		'rollup.config.js'. 		'rollup'. 
		'rollup.config.ts'. 		'rollup'. 
		'rollup.config.cjs'. 	'rollup'. 
		'rollup.config.mjs'. 	'rollup'. 
		'webpack.config.js'. 	'webpack'. 
		'webpack.config.ts'. 	'webpack'. 
		'webpack.config.cjs'. 	'webpack'. 
		'vite.config.js'. 		'vite'. 
		'vite.config.ts'. 		'vite'. 
		'vite.config.cjs'. 		'vite'. 
		'vite.config.mjs'. 		'vite'. 
		'LICENSE'. 				'license'. 
		'LICENSE.txt'. 			'license'. 
		'LICENSE.md'. 			'license'. 
		'LICENCE'. 				'license'. 
		'.env'. 					'dotenv'.
		'Procfile'. 				'procfile'. 
		'.browserslistrc'. 		'browserslist'. 
		'CODEOWNERS'. 			'codeowners'. 
		'dependabot.yml'. 		'dependabot'. 
		'dependabot.yaml'. 		'dependabot' }
]

{ #category : 'accessing' }
PulsarFileModel class >> languageForExtension: anExtensionString [

	^ self languagesByExtension 
		at: anExtensionString 
		ifAbsent: [ nil ]
]

{ #category : 'accessing' }
PulsarFileModel class >> languageForName: aString [

	^ self languagesByName at: aString ifAbsent: [ nil ]
]

{ #category : 'accessing' }
PulsarFileModel class >> languagesByExtension [

	^ LanguagesByExtension ifNil: [
		LanguagesByExtension := Dictionary newFromPairs: self extensionIconPairs ]
]

{ #category : 'accessing' }
PulsarFileModel class >> languagesByName [

	^ LanguagesByName ifNil: [
		LanguagesByName := Dictionary newFromPairs: self languageByNamePairs ]
]

{ #category : 'accessing' }
PulsarFileModel class >> nameBasedIconFor: aFilenameString [
	"Answer the icon key for a name-based file, or nil if not recognized."

	^ self nameBasedIcons at: aFilenameString ifAbsent: [ nil ]
]

{ #category : 'accessing' }
PulsarFileModel class >> nameBasedIcons [
	"Maps exact filenames (case-insensitive first check) to icon keys."

	^ NameBasedIcons ifNil: [
		NameBasedIcons := Dictionary newFromPairs: self nameIconPairs ]
]

{ #category : 'accessing' }
PulsarFileModel class >> nameIconPairs [

	^ { 
	'CMakeLists.txt'. 		'cmake'. 
	'Dockerfile'. 			'docker'. 
	'meson.build'. 			'meson'. 
	'.editorconfig'. 		'editorconfig'. 
	'.eslintrc.js'. 			'eslint'. 
	'.eslintrc.cjs'. 		'eslint'. 
	'.eslintrc.yaml'. 		'eslint'. 
	'.eslintrc.yml'. 		'eslint'. 
	'.eslintrc.json'. 		'eslint'. 
	'.eslintrc'. 			'eslint'. 
	'.eslintignore'. 		'eslint'. 
	'.prettierrc'. 			'prettier'. 
	'.prettierrc.js'. 		'prettier'. 
	'.prettierrc.json'. 		'prettier'. 
	'.prettierrc.yaml'. 		'prettier'. 
	'.prettierrc.yml'. 		'prettier'. 
	'.prettierrc.toml'. 		'prettier'. 
	'.prettierignore'. 		'prettier'. 
	'.gitignore'. 			'git'. 
	'.gitattributes'. 		'git'. 
	'.gitmodules'. 			'git'. 
	'.babelrc'. 				'babel'.
	'.babelrc.js'. 			'babel'. 
	'.babelrc.json'. 		'babel'. 
	'babel.config.js'. 		'babel'. 
	'babel.config.json'.		'babel'. 
	'nginx.conf'. 			'nginx'. 
	'package.json'. 			'npm'. 
	'yarn.lock'. 			'yarn'. 
	'pnpm-lock.yaml'. 		'pnpm'. 
	'composer.json'. 		'composer'. 
	'.travis.yml'. 			'travis'. 
	'.gitlab-ci.yml'. 		'gitlab'. 
	'Jenkinsfile'. 			'jenkins'. 
	'.circleci'. 			'circleci'. 
	'rollup.config.js'. 		'rollup'. 
	'rollup.config.ts'. 		'rollup'. 
	'rollup.config.cjs'.		'rollup'. 
	'rollup.config.mjs'.		'rollup'. 
	'webpack.config.js'.		'webpack'.
	'webpack.config.ts'.		'webpack'. 
	'webpack.config.cjs'.	'webpack'. 
	'vite.config.js'. 		'vite'. 
	'vite.config.ts'. 		'vite'. 
	'vite.config.cjs'.		'vite'. 
	'vite.config.mjs'. 		'vite'. 
	'LICENSE'. 				'license'. 
	'LICENSE.txt'. 			'license'. 
	'LICENSE.md'.			'license'. 
	'LICENCE'. 				'license'. 
	'.env'. 					'dotenv'. 
	'Procfile'. 				'procfile'. 
	'.browserslistrc'. 		'browserslist'. 
	'CODEOWNERS'. 			'codeowners'. 
	'dependabot.yml'. 		'dependabot'. 
	'dependabot.yaml'. 		'dependabot' }
]

{ #category : 'initialization' }
PulsarFileModel class >> reset [
	<script>
	
	LanguagesByExtension := nil.
	LanguagesByName := nil.
	NameBasedIcons := nil
]

{ #category : 'accessing' }
PulsarFileModel >> fullName [

	^ self entity fullName
]

{ #category : 'testing' }
PulsarFileModel >> hasPulsarEditor [

	^ true
]

{ #category : 'accessing - ui' }
PulsarFileModel >> iconName [
	| basename iconKey ext |
	
	basename := self entity basename.
	iconKey := self class nameBasedIconFor: basename.
	iconKey ifNotNil: [ ^ 'file-name-' , iconKey ].

	ext := self entity extension asLowercase.
	ext ifEmpty: [ ^ 'file' ].
	^ 'file-extension-' , ext
]

{ #category : 'testing' }
PulsarFileModel >> isDirectory [

	^ false
]

{ #category : 'testing' }
PulsarFileModel >> isSmalltalk [

	^ self entity extension = 'st'
]

{ #category : 'testing' }
PulsarFileModel >> matches: aString [

	^ self name includesSubstring: aString caseSensitive: false
]

{ #category : 'accessing' }
PulsarFileModel >> name [

	^ self entity basename
]

{ #category : 'actions' }
PulsarFileModel >> openInOSFileBrowser [

	^ self entity openInOSFileBrowser
]

{ #category : 'accessing' }
PulsarFileModel >> pageTitle [

	^ self entity basename
]

{ #category : 'accessing - ui' }
PulsarFileModel >> pulsarEditorClass [

	^ PulsarFileEditor
]

{ #category : 'accessing' }
PulsarFileModel >> sourceCode [

	^ self entity contents
]

{ #category : 'accessing' }
PulsarFileModel >> sourceCodeLanguage [
	"Return the GtkSourceView language identifier for this file, auto-detected from its filename or extension."

	^ self class guessLanguageOfFile: self entity
]

{ #category : 'accessing' }
PulsarFileModel >> spotterTitle [

	^ self entity basename
]

{ #category : 'updating' }
PulsarFileModel >> updateWith: aString [
	"Write the edited content back to the file."
	| bakReference |	
	
	"make backup"
	bakReference := self entity copy withExtension: (self entity extension, '~').
	bakReference ensureDelete.
	self entity copy renameTo: bakReference basename.
	
	"write new contents"
	self entity writeStreamDo: [ :stream | stream nextPutAll: aString ].
	
	^ true
]

{ #category : 'updating' }
PulsarFileModel >> updateWith: aString notifying: anInteractionModel [

	^ self updateWith: aString
]

{ #category : 'accessing' }
PulsarFileModel >> windowTitle [

	^ self entity basename
]
