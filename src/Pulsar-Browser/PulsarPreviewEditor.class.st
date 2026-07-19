"
A preview editor that follows the current selection. 
It is pinned and non-closable, delegating its contents to an inner editor chosen from the selected entity's pulsarEditorClass. 
When the user navigates (selects) through entities, the preview editor adapts by showing the appropriate editor (method, class, package, etc.) without opening a new docked panel.
"
Class {
	#name : 'PulsarPreviewEditor',
	#superclass : 'PulsarBaseView',
	#instVars : [
		'innerEditor'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing' }
PulsarPreviewEditor class >> defaultTitle [

	^ 'Preview'
]

{ #category : 'testing' }
PulsarPreviewEditor >> canBeListed [

	^ false
]

{ #category : 'layout' }
PulsarPreviewEditor >> defaultLayout [

	^ SpBoxLayout newVertical
]

{ #category : 'events' }
PulsarPreviewEditor >> eventModelSelected: anAnnouncement [
	| selectedModel editorClass |
	
	selectedModel := anAnnouncement value.
	selectedModel hasPulsarEditor ifFalse: [ ^ self ].
	editorClass := selectedModel pulsarEditorClass.
	
	innerEditor class == editorClass
		ifTrue: [ innerEditor model: selectedModel ]
		ifFalse: [ self replaceEditorWith: editorClass model: selectedModel ]
]

{ #category : 'initialization' }
PulsarPreviewEditor >> initialize [

	model := PulsarPreviewModel new.
	super initialize.
	
]

{ #category : 'initialization' }
PulsarPreviewEditor >> initializePanelWidget: aPanelWidgetPresenter [

	super initializePanelWidget: aPanelWidgetPresenter.
	aPanelWidgetPresenter 
		pinned: true;
		windowIcon: (self iconNamed: 'preview')
]

{ #category : 'initialization' }
PulsarPreviewEditor >> initializePresenters [
	"Nothing to add initially. The inner editor is added lazily on first model selection."

	
]

{ #category : 'initialization' }
PulsarPreviewEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: (self iconNamed: 'preview')
]

{ #category : 'private' }
PulsarPreviewEditor >> panelPlacedIconName [

	^ 'preview.neutral'
]

{ #category : 'initialization' }
PulsarPreviewEditor >> registerToEvents [

	super registerToEvents.
	self announcer when: PulsarModelSelected send: #eventModelSelected: to: self
]

{ #category : 'events' }
PulsarPreviewEditor >> replaceEditorWith: editorClass model: selectedModel [
	| newEditor |
	
	newEditor := self instantiate: editorClass on: selectedModel.
	newEditor registerToBrowser: self window.
	innerEditor 
		ifNotNil: [ self layout replace: innerEditor with: newEditor ]
		ifNil: [ self layout add: newEditor ].
	innerEditor := newEditor
]
