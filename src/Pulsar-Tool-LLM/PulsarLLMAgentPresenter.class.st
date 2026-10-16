Class {
	#name : 'PulsarLLMAgentPresenter',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTPopover',
	#classTraits : 'PulsarTPopover classTrait',
	#instVars : [
		'toolbarPresenter',
		'terminalPresenter',
		'styler'
	],
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'initialization' }
PulsarLLMAgentPresenter >> addPopoverControls [

	toolbarPresenter addPresenter: self newPopoverControlBoxPresenter
]

{ #category : 'testing' }
PulsarLLMAgentPresenter >> canBeListed [

	^ true
]

{ #category : 'layout' }
PulsarLLMAgentPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: terminalPresenter;
		"add: inputPresenter expand: false;"
		yourself
]

{ #category : 'private - actions' }
PulsarLLMAgentPresenter >> doComment [
	
	self scheduleTask: [
		self model commentOn: self ]
]

{ #category : 'private - actions' }
PulsarLLMAgentPresenter >> doExplain [
	
	self scheduleTask: [
		self model explainOn: self ]
]

{ #category : 'api' }
PulsarLLMAgentPresenter >> feed: aString [

	self feed: aString kind: #text
]

{ #category : 'api' }
PulsarLLMAgentPresenter >> feed: aChunk kind: aKind [
	"Display a streamed answer chunk in the terminal."

	terminalPresenter feed: (self styler format: aChunk kind: aKind)
]

{ #category : 'initialization' }
PulsarLLMAgentPresenter >> initializePopover: aPopoverPresenter [

	aPopoverPresenter bePositionBottom.
	self addPopoverControls.
	aPopoverPresenter addShortcutWith: [ :action | action 
		shortcutKey: KeyboardKey down mod3;
		action: [ 
			self withPopoverDo: #dismiss.
			self notifyActivateEntity: self model ] ]
]

{ #category : 'initialization' }
PulsarLLMAgentPresenter >> initializePresenters [

	self addStyle: 'pulsarFlyingBrowser'.
	self addStyle: 'pulsarAgentFlyingBrowser'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (self model actionsWithContextOn: self).

	terminalPresenter := self instantiate: VteTerminalPresenter
]

{ #category : 'private - announcing' }
PulsarLLMAgentPresenter >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private - notifying' }
PulsarLLMAgentPresenter >> notifyEditorClosed [

	self model closeSession.
	super notifyEditorClosed
]

{ #category : 'api' }
PulsarLLMAgentPresenter >> resetStream [
	"Drop the stream styler so the next query starts with fresh state."

	styler := nil
]

{ #category : 'accessing' }
PulsarLLMAgentPresenter >> styler [

	^ styler ifNil: [ styler := PulsarLLMAgentStreamStyler new ]
]
