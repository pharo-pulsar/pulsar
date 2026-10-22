"
I am the view of a Pulsar LLM agent. I host a terminal-like output area and a toolbar, and I drive a `PulsarLLMAgentModel` that holds the LLM session for the entity under inspection (a class, method, debugger, or repository).

My model asks the LLM for an explanation or a comment, and I render the streamed answer as it arrives. Each chunk is styled by a `PulsarLLMAgentStreamStyler` and appended to a `VteTerminalPresenter`. Queries run in the background through TaskIt, and I track whether one is in progress so the toolbar can reflect it. If a query fails, the error is shown in the same output area.

I am usually shown inside a popover opened from a Pulsar tool. Closing my editor releases the agent session, and I can be detached into a separate browser window.

## Example

Given an agent model created for a class model, a caller presenter instantiates the view:

```smalltalk
caller
    instantiate: PulsarLLMAgentPresenter
    on: (PulsarLLMClassAgentModel on: aClassModel)
```

## References

- `PulsarLLMAgentModel` — the agent I display and whose session I drive.
- `PulsarLLMAgent>>newAgentPresenter` — creates me for an agent.
- `PulsarLLMAgentStreamStyler` — turns streamed chunks into ANSI-styled text.
- `PulsarBaseView` — my superclass in the Pulsar browser.
"
Class {
	#name : 'PulsarLLMAgentPresenter',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTPopover',
	#classTraits : 'PulsarTPopover classTrait',
	#instVars : [
		'toolbarPresenter',
		'terminalPresenter',
		'styler',
		'toolbarActions',
		'queryInProgress'
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

{ #category : 'private - actions' }
PulsarLLMAgentPresenter >> cancelQuery [

	self feed: String cr , '(cancelled)' , String cr kind: #text.
	self model cancelQuery
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

	self runQuery: [ self model commentOn: self ]
]

{ #category : 'private - actions' }
PulsarLLMAgentPresenter >> doExplain [

	self runQuery: [ self model explainOn: self ]
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
	| shouldCloseSession |

	shouldCloseSession := true.
	aPopoverPresenter bePositionBottom.
	aPopoverPresenter whenClosedDo: [ 
		shouldCloseSession ifTrue: [ 
			self notifyEditorClosed ] ].
	self addPopoverControls.
	aPopoverPresenter addShortcutWith: [ :action | action 
		shortcutKey: KeyboardKey down mod3;
		action: [ 
			shouldCloseSession := false.
			[ self withPopoverDo: #dismiss ]
			ensure: [ shouldCloseSession := true ].
			self notifyActivateEntity: self model ] ]
]

{ #category : 'initialization' }
PulsarLLMAgentPresenter >> initializePresenters [

	self addStyle: 'pulsarFlyingBrowser'.
	self addStyle: 'pulsarAgentFlyingBrowser'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (toolbarActions := self model actionsWithContextOn: self).

	terminalPresenter := self instantiate: VteTerminalPresenter
]

{ #category : 'testing' }
PulsarLLMAgentPresenter >> isQuerying [

	^ queryInProgress ifNil: [ false ]
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

{ #category : 'private - actions' }
PulsarLLMAgentPresenter >> runQuery: aBlock [
	"Run the query block in the background while tracking it as the ongoing inference."

	queryInProgress := true.
	self updateToolbar.
	self scheduleTask: [
			[
				[ aBlock value ]
					on: Error
					do: [ :e | self feed: (e messageText ifNil: [ e description ]) kind: #error ] ] ensure: [
					queryInProgress := false.
					self updateToolbar ] ]
]

{ #category : 'accessing' }
PulsarLLMAgentPresenter >> styler [

	^ styler ifNil: [ styler := PulsarLLMAgentStreamStyler new ]
]

{ #category : 'api' }
PulsarLLMAgentPresenter >> updateToolbar [

	toolbarActions ifNil: [ ^ self ].
	toolbarActions allCommands do: [ :each | each updateEnableStatus ]
]
