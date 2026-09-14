"
An editor for arbitrary text files.

Unlike `PulsarMethodEditor` or `PulsarClassEditor`, this editor is not coupled to the Pharo image. It uses `SeEditorPresenter` for syntax highlighting with language auto-detection based on file extension, and persists changes directly to disk.
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

{ #category : 'private - actions' }
PulsarFileEditor >> closeEditorPanel [
	
	self withPanelWidgetDo: [ :aPanelWindow | aPanelWindow close ]
]

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
PulsarFileEditor >> doConfirmCloseAfterExternalDeletion [
	"Ask the user whether to close the editor after the file was deleted on disk."
	| okToClose |
	
	okToClose := self application newConfirm
		title: 'File deleted';
		message: (f'[self model name] was deleted on disk. Close the editor?');
		acceptLabel: 'Close';
		openModalWithParent: self window.
	okToClose ifFalse: [ ^ self ].
	
	self closeEditorPanel
]

{ #category : 'private - actions' }
PulsarFileEditor >> doConfirmExternalChangeReload: contentString [
	"Ask the user to reload the file from disk, discarding local changes."
	| okToReload |
	
	okToReload := self application newConfirm
		title: 'File changed';
		message: ('{1} was modified on disk. Reload and discard your changes?' format: { self model name });
		acceptLabel: 'Reload';
		openModalWithParent: self window.
	okToReload ifFalse: [ ^ self ].
	self reloadContent: contentString
]

{ #category : 'events' }
PulsarFileEditor >> doHandleExternalFileDeletion [
	"React to the external deletion of the file: close a clean editor, ask first if dirty."

	self isDirty ifFalse: [ ^ self closeEditorPanel ].
	self doConfirmCloseAfterExternalDeletion
]

{ #category : 'private - actions' }
PulsarFileEditor >> doOpenCurrentFolder [

	self model openInOSFileBrowser
]

{ #category : 'events' }
PulsarFileEditor >> doReactToChangedContent: contentString [
	"Reload the editor with the new content, asking first if it is dirty."

	self model entity exists ifFalse: [ ^ self doHandleExternalFileDeletion ].
	contentString = self originalContent ifTrue: [ ^ self ].
	self isDirty
		ifTrue: [ self doConfirmExternalChangeReload: contentString ]
		ifFalse: [ self reloadContent: contentString ]
]

{ #category : 'events' }
PulsarFileEditor >> doReactToExternalFileChange [
	"React to an external change of the file on disk."
	
	self model ifNil: [ ^ self ].
	self model entity exists ifFalse: [ ^ self doHandleExternalFileDeletion ].
	self doReactToChangedContent: self model sourceCode
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
	
	editorPresenter := (self model isNotNil and: [ self model isSmalltalk ])
		ifTrue: [ self newCode beForScripting ]
		ifFalse: [ self instantiate: SeEditorPresenter ].
	
	editorPresenter
		addStyle: 'editor';
		withEditionContextMenu;
		systemNavigation: (self systemNavigationWithResponder: editorPresenter)
]

{ #category : 'private - updating' }
PulsarFileEditor >> markDirty [
	
	^ super markDirty
]

{ #category : 'private - notifying' }
PulsarFileEditor >> notifyEditorClosed [

	super notifyEditorClosed.
	self windowClosed
]

{ #category : 'private' }
PulsarFileEditor >> originalContent [
	
	^ self model entity exists
		ifTrue: [ self model sourceCode ]
		ifFalse: [ nil ]
]

{ #category : 'initialization' }
PulsarFileEditor >> registerToSystemEvents [
	"No Pharo system events to listen to for a file editor."

	
]

{ #category : 'private - actions' }
PulsarFileEditor >> reloadContent: contentString [
	"Replace the editor text with the given content without marking it dirty."
	
	self updatingWhile: [
		editorPresenter removeAllTextSegmentDecorations.
		editorPresenter text: contentString ].
	self unmarkDirty
]

{ #category : 'accessing - snapshot' }
PulsarFileEditor >> snapshot [

	^ PulsarFileSnapshot on: self
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
	| result |
	
	result := self model updateWith: aString.
	self model parentModel 
		ifNotNil: [ :dir | self notificationCenter announce: (PulsarModelChanged newValue: dir) ].
	
	^ result
]

{ #category : 'initialization' }
PulsarFileEditor >> updatePresenter [
	| source |
	
	self model ifNil: [ ^ self ].
	self model ensureMonitoringDo: [ self doReactToExternalFileChange ].
	self scheduleJob: [
		source := self model sourceCode.
		self updatingWhile: [
			self model isSmalltalk ifFalse: [ 
				self model sourceCodeLanguage
					ifNotNil: [ :language | editorPresenter language: language ] ].
			editorPresenter text: source ].
		self updateBreadcrumbs ]
]

{ #category : 'private' }
PulsarFileEditor >> windowClosed [
	
	self model stopMonitoring
]
