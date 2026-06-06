"
Provides file type icons from the vscode-icons set (https://github.com/vscode-icons/vscode-icons ).

Icons are stored as SVG files in the FileTypes/svg resources directory and are loaded directly without tinting, as they already have colors. The table maps 'file-extension-{ext}' names to icon filenames.

This icons are stored as SVG in an accessinble place for the image and transformed on the fly using [pharo-resvg](https://github.com/pharo-cig/pharo/resvg). This means this provider can adapt itself to whatever the scale of icons will be required.

"
Class {
	#name : 'PulsarVSCodeFileTypeIconProvider',
	#superclass : 'SpLocationIconProvider',
	#instVars : [
		'table'
	],
	#category : 'Pulsar-Tool-FileEditor-IconProvider',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'IconProvider'
}

{ #category : 'accessing' }
PulsarVSCodeFileTypeIconProvider class >> iconDirectory [
	"Directory where file type SVG icons are stored."

	^ FileLocator pulsarResources / 'FileTypes' / 'svg'
]

{ #category : 'initialization' }
PulsarVSCodeFileTypeIconProvider >> createNameTable [

	"Maps file-name-{key} internal names to file_type icon filenames (without .svg extension)."

	^ #(
		('file-name-babel' 'file_type_babel')
		('file-name-browserslist' 'file_type_browserslist')
		('file-name-circleci' 'file_type_circleci')
		('file-name-cmake' 'file_type_cmake')
		('file-name-codeowners' 'file_type_codeowners')
		('file-name-composer' 'file_type_composer')
		('file-name-dependabot' 'file_type_dependabot')
		('file-name-docker' 'file_type_docker')
		('file-name-dockerfile' 'file_type_docker')
		('file-name-dotenv' 'file_type_dotenv')
		('file-name-editorconfig' 'file_type_editorconfig')
		('file-name-eslint' 'file_type_eslint')
		('file-name-git' 'file_type_git')
		('file-name-gitlab' 'file_type_gitlab')
		('file-name-jenkins' 'file_type_jenkins')
		('file-name-license' 'file_type_license')
		('file-name-meson' 'file_type_meson')
		('file-name-nginx' 'file_type_nginx')
		('file-name-npm' 'file_type_npm')
		('file-name-pnpm' 'file_type_pnpm')
		('file-name-prettier' 'file_type_prettier')
		('file-name-procfile' 'file_type_procfile')
		('file-name-rollup' 'file_type_rollup')
		('file-name-travis' 'file_type_travis')
		('file-name-vite' 'file_type_vite')
		('file-name-webpack' 'file_type_webpack')
		('file-name-yarn' 'file_type_yarn')
	)
]

{ #category : 'initialization' }
PulsarVSCodeFileTypeIconProvider >> createTable [

	"Maps file-extension-{ext} internal names to file_type icon filenames (without .svg extension)."

	^ #(
		('file-extension-default' 'file_type_default')
		('file-extension-folder' 'file_type_folder')
		('file-extension-adb' 'file_type_ada')
		('file-extension-adoc' 'file_type_asciidoc')
		('file-extension-ads' 'file_type_ada')
		('file-extension-as' 'file_type_actionscript')
		('file-extension-asciidoc' 'file_type_asciidoc')
		('file-extension-asp' 'file_type_asp')
		('file-extension-astro' 'file_type_astro')
		('file-extension-awk' 'file_type_awk')
		('file-extension-bat' 'file_type_bat')
		('file-extension-c' 'file_type_c')
		('file-extension-cbl' 'file_type_cobol')
		('file-extension-cfg' 'file_type_ini')
		('file-extension-cl' 'file_type_opencl')
		('file-extension-cmd' 'file_type_bat')
		('file-extension-cob' 'file_type_cobol')
		('file-extension-comp' 'file_type_glsl')
		('file-extension-cpp' 'file_type_cpp')
		('file-extension-cs' 'file_type_csharp')
		('file-extension-css' 'file_type_css')
		('file-extension-cu' 'file_type_cuda')
		('file-extension-cuh' 'file_type_cuda')
		('file-extension-d' 'file_type_dlang')
		('file-extension-dart' 'file_type_dartlang')
		('file-extension-diff' 'file_type_diff')
		('file-extension-dot' 'file_type_graphviz')
		('file-extension-dtd' 'file_type_dtd')
		('file-extension-erb' 'file_type_erb')
		('file-extension-erl' 'file_type_erlang')
		('file-extension-ex' 'file_type_elixir')
		('file-extension-exs' 'file_type_elixir')
		('file-extension-f03' 'file_type_fortran')
		('file-extension-f90' 'file_type_fortran')
		('file-extension-f95' 'file_type_fortran')
		('file-extension-frag' 'file_type_glsl')
		('file-extension-fs' 'file_type_fsharp')
		('file-extension-fsi' 'file_type_fsharp')
		('file-extension-fsx' 'file_type_fsharp')
		('file-extension-gd' 'file_type_gdscript')
		('file-extension-geom' 'file_type_glsl')
		('file-extension-glsl' 'file_type_glsl')
		('file-extension-go' 'file_type_go')
		('file-extension-gradle' 'file_type_gradle')
		('file-extension-groovy' 'file_type_groovy')
		('file-extension-gv' 'file_type_graphviz')
		('file-extension-gvy' 'file_type_groovy')
		('file-extension-h' 'file_type_c')
		('file-extension-hh' 'file_type_cppheader')
		('file-extension-hpp' 'file_type_cppheader')
		('file-extension-hrl' 'file_type_erlang')
		('file-extension-hs' 'file_type_haskell')
		('file-extension-html' 'file_type_html')
		('file-extension-hx' 'file_type_haxe')
		('file-extension-hxx' 'file_type_cppheader')
		('file-extension-ini' 'file_type_ini')
		('file-extension-java' 'file_type_java')
		('file-extension-jl' 'file_type_julia')
		('file-extension-js' 'file_type_js')
		('file-extension-json' 'file_type_json')
		('file-extension-kt' 'file_type_kotlin')
		('file-extension-l' 'file_type_lex')
		('file-extension-lean' 'file_type_lean')
		('file-extension-less' 'file_type_less')
		('file-extension-lex' 'file_type_lex')
		('file-extension-lhs' 'file_type_haskell')
		('file-extension-lisp' 'file_type_lisp')
		('file-extension-lsp' 'file_type_lisp')
		('file-extension-lua' 'file_type_lua')
		('file-extension-md' 'file_type_markdown')
		('file-extension-ml' 'file_type_ocaml')
		('file-extension-mli' 'file_type_ocaml')
		('file-extension-nix' 'file_type_nix')
		('file-extension-nsi' 'file_type_nsi')
		('file-extension-patch' 'file_type_diff')
		('file-extension-php' 'file_type_php')
		('file-extension-pl' 'file_type_perl')
		('file-extension-pm' 'file_type_perl')
		('file-extension-pp' 'file_type_puppet')
		('file-extension-pro' 'file_type_prolog')
		('file-extension-ps1' 'file_type_powershell')
		('file-extension-psm1' 'file_type_powershell')
		('file-extension-py' 'file_type_python')
		('file-extension-r' 'file_type_r')
		('file-extension-rb' 'file_type_ruby')
		('file-extension-rq' 'file_type_sparql')
		('file-extension-rs' 'file_type_rust')
		('file-extension-scala' 'file_type_scala')
		('file-extension-sce' 'file_type_scilab')
		('file-extension-sci' 'file_type_scilab')
		('file-extension-scss' 'file_type_scss')
		('file-extension-sh' 'file_type_shell')
		('file-extension-sol' 'file_type_solidity')
		('file-extension-sparql' 'file_type_sparql')
		('file-extension-sql' 'file_type_sql')
		('file-extension-sv' 'file_type_systemverilog')
		('file-extension-svg' 'file_type_xml')
		('file-extension-svh' 'file_type_systemverilog')
		('file-extension-swift' 'file_type_swift')
		('file-extension-tcl' 'file_type_tcl')
		('file-extension-tera' 'file_type_tera')
		('file-extension-tesc' 'file_type_glsl')
		('file-extension-tese' 'file_type_glsl')
		('file-extension-tex' 'file_type_tex')
		('file-extension-tf' 'file_type_terraform')
		('file-extension-tfvars' 'file_type_terraform')
		('file-extension-toml' 'file_type_toml')
		('file-extension-ts' 'file_type_typescript')
		('file-extension-tsx' 'file_type_typescript')
		('file-extension-twig' 'file_type_twig')
		('file-extension-v' 'file_type_verilog')
		('file-extension-vala' 'file_type_vala')
		('file-extension-vapi' 'file_type_vala')
		('file-extension-vb' 'file_type_vb')
		('file-extension-vert' 'file_type_glsl')
		('file-extension-vhd' 'file_type_vhdl')
		('file-extension-vhdl' 'file_type_vhdl')
		('file-extension-xml' 'file_type_xml')
		('file-extension-xsl' 'file_type_xsl')
		('file-extension-y' 'file_type_yacc')
		('file-extension-yaml' 'file_type_yaml')
		('file-extension-yml' 'file_type_yaml')
		('file-extension-yy' 'file_type_yacc')
		('file-extension-zig' 'file_type_zig')
	)
]

{ #category : 'accessing' }
PulsarVSCodeFileTypeIconProvider >> iconNamed: aName ifAbsent: aBlock [
	
	^ super 
		iconNamed: aName 
		ifAbsent: [ 
			"just answer default if we were asking for a file"
			(aName isNotNil 
				and: [ aName beginsWithAnyOf: #('file-extension-' 'file-name-') ]) 
				ifTrue: [
					super 
						iconNamed: 'file-extension-default'
						ifAbsent: aBlock ]
				ifFalse: [
					aBlock value ] ]
]

{ #category : 'initialization' }
PulsarVSCodeFileTypeIconProvider >> initialize [

	super initialize.
	self initializeTable
]

{ #category : 'initialization' }
PulsarVSCodeFileTypeIconProvider >> initializeTable [

	table := Dictionary new.
	self createTable do: [ :entry | table at: entry first put: entry second ].
	self createNameTable do: [ :entry | table at: entry first put: entry second ]
]

{ #category : 'utilities' }
PulsarVSCodeFileTypeIconProvider >> loadIconNamed: aName [
	"Look up the icon filename from the table, then load the SVG."

	| iconName |
	iconName := table at: aName ifAbsent: [ ^ nil ].
	self locations do: [ :each |
			| ref |
			ref := each / iconName withExtension: 'svg'.
			ref exists ifTrue: [ ^ self loadSvgIcon: ref ] ].
	^ nil
]

{ #category : 'utilities' }
PulsarVSCodeFileTypeIconProvider >> loadSvgIcon: svgReference [
	"Load an SVG icon and render it through LibRsvg, without tinting."

	^ GRunLoop defer: [ LibRsvg renderFromString: svgReference contents size: 24 @ 24 ]
]
