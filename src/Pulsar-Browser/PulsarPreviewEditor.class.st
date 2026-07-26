"
A preview editor that follows the current selection. 
It is pinned and non-closable, delegating its contents to an inner editor chosen from the selected entity's pulsarEditorClass. 
When the user navigates (selects) through entities, the preview editor adapts by showing the appropriate editor (method, class, package, etc.) without opening a new docked panel.
"
Class {
	#name : 'PulsarPreviewEditor',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTEditor',
	#classTraits : 'PulsarTEditor classTrait',
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
	"no, the preview editor will not be shown at the stack editor list or alike"
	
	^ false
]

{ #category : 'layout' }
PulsarPreviewEditor >> defaultLayout [

	^ SpBoxLayout newVertical
]

{ #category : 'events' }
PulsarPreviewEditor >> eventModelSelected: anAnnouncement [
	| selectedModel editorClass |
	
	anAnnouncement value hasPulsarEditor ifFalse: [ ^ self ].

	selectedModel := anAnnouncement value copy.
	self model updateEntityWith: selectedModel.
	editorClass := selectedModel pulsarEditorClass.
	innerEditor class == editorClass
		ifTrue: [ innerEditor model: selectedModel ]
		ifFalse: [ self replaceEditorWith: editorClass model: selectedModel ]
]

{ #category : 'initialization' }
PulsarPreviewEditor >> initializePanelWidget: aPanelWidgetPresenter [

	super initializePanelWidget: aPanelWidgetPresenter.
	aPanelWidgetPresenter 
		pinned: true;
		windowIcon: (self iconNamed: self panelPlacedIconName)
]

{ #category : 'initialization' }
PulsarPreviewEditor >> initializePresenters [
	"Nothing to add initially. The inner editor is added lazily on first model selection."

	self addStyle: 'pulsarPreviewEditor'
]

{ #category : 'initialization' }
PulsarPreviewEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: self panelPlacedIconName
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
