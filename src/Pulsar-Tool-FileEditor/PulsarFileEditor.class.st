"
An editor for arbitrary text files.

Unlike PulsarMethodEditor or PulsarClassEditor, this editor is not coupled to the Pharo image. It uses SeEditorPresenter for syntax highlighting with language auto-detection based on file extension, and persists changes directly to disk.
"
Class {
	#name : 'PulsarFileEditor',
	#superclass : 'PulsarEditor',
	#traits : 'PulsarTSnapshot',
	#classTraits : 'PulsarTSnapshot classTrait',
	#category : 'Pulsar-Tool-FileEditor-View',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'View'
}

{ #category : 'private - definitions' }
PulsarFileEditor >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #navigation with: [ :group | group 
		priority: 100;
		name: 'Actions';
		beDisplayedAsGroup;
		addActionWith: [ :action | action
			name: 'Open file location';
			iconName: 'open';
			description: 'Open current file location on the external file manager';
			action: [ self doOpenCurrentFolder ] ] ]
]

{ #category : 'private - definitions' }
PulsarFileEditor >> defineNavigationActionsOn: aBuilder [
	<dockActions>

]

{ #category : 'private - actions' }
PulsarFileEditor >> doBrowseSendersCommand: aCommand [
	"Not applicable for a file editor."

	
]

{ #category : 'private - actions' }
PulsarFileEditor >> doOpenCurrentFolder [

	self model entity openInOSFileBrowser
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

{ #category : 'events' }
PulsarFileEditor >> eventModelRemoved: anAnnouncememnt [ 

	anAnnouncememnt value = self model ifFalse: [ ^ self ].

	self withPanelWidgetDo: [ :aPanelWindow | aPanelWindow close ]
]

{ #category : 'initialization' }
PulsarFileEditor >> initializeEditor [
	
	editorPresenter := self instantiate: SeEditorPresenter.
	editorPresenter
		addStyle: 'editor';
		withEditionContextMenu;
		systemNavigation: (self systemNavigationWithResponder: editorPresenter)
]

{ #category : 'private - updating' }
PulsarFileEditor >> markDirty [
	
	^ super markDirty
]

{ #category : 'private' }
PulsarFileEditor >> originalContent [

	^ self model sourceCode
]

{ #category : 'initialization' }
PulsarFileEditor >> registerToSystemEvents [
	"No Pharo system events to listen to for a file editor."

	
]

{ #category : 'accessing - snapshot' }
PulsarFileEditor >> snapshot [

	^ PulsarDirectorySnapshot on: self
]

{ #category : 'accessing' }
PulsarFileEditor >> spotterTitle [

	^ self model name
]

{ #category : 'initialization' }
PulsarFileEditor >> updateBreadcrumbs [

	| fullPath |
	fullPath := self model entity fullName.
	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb 
			addSegment: fullPath;
			addButtonSegment: 'copy-to-clipboard'
				help: ('Copy {1} to the clipboard' format: { self model fullName })
				action: [ self doCopyToClipboard ] ]
]

{ #category : 'private - actions' }
PulsarFileEditor >> updateModel: aString [

	^ self model updateWith: aString
]

{ #category : 'initialization' }
PulsarFileEditor >> updatePresenter [

	self model ifNil: [ ^ self ].

	self updatingWhile: [
		self model sourceCodeLanguage
			ifNotNil: [ :language | editorPresenter language: language ].
		editorPresenter text: self model sourceCode ].
	self updateBreadcrumbs
]
