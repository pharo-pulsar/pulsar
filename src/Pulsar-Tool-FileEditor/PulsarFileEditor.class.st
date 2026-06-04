"
An editor for arbitrary text files.

Unlike PulsarMethodEditor or PulsarClassEditor, this editor is not coupled to the Pharo image. It uses SeEditorPresenter for syntax highlighting with language auto-detection based on file extension, and persists changes directly to disk.
"
Class {
	#name : 'PulsarFileEditor',
	#superclass : 'PulsarEditor',
	#category : 'Pulsar-Tool-FileEditor-View',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'View'
}

{ #category : 'private - actions' }
PulsarFileEditor >> doBrowseSendersCommand: aCommand [
	"Not applicable for a file editor."

	
]

{ #category : 'private - actions' }
PulsarFileEditor >> doRunTestCommand: aCommand [
	"Not applicable for a file editor."

	
]

{ #category : 'private - actions' }
PulsarFileEditor >> doShowHierarchy: aCommand [
	"Not applicable for a file editor."

	
]

{ #category : 'private - actions' }
PulsarFileEditor >> editorContextMenuActions [

	^ SpActionGroup new
]

{ #category : 'initialization' }
PulsarFileEditor >> initializeEditor [
	| language |
	
	editorPresenter := self instantiate: SeEditorPresenter.
	editorPresenter
		addStyle: 'editor';
		withEditionContextMenu.
	language := self model sourceCodeLanguage.
	language ifNotNil: [ editorPresenter language: language ]
]

{ #category : 'private' }
PulsarFileEditor >> originalContent [

	^ self model sourceCode
]

{ #category : 'initialization' }
PulsarFileEditor >> registerToSystemEvents [
	"No Pharo system events to listen to for a file editor."

	
]

{ #category : 'accessing' }
PulsarFileEditor >> spotterTitle [

	^ self model name
]

{ #category : 'initialization' }
PulsarFileEditor >> updateBreadcrumbs [

	| fullPath |
	fullPath := self model entity fullName.
	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | aBreadcrumb addSegment: fullPath ]
]

{ #category : 'initialization' }
PulsarFileEditor >> updatePresenter [

	editorPresenter text: self model sourceCode.
	self updateBreadcrumbs
]
