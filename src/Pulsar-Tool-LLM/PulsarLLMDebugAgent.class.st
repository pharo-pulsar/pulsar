"
# PulsarLLMDebugAgent

I bind a debug session to the Pulsar LLM assistant.

## Why I exist
The stack of an interrupted process can be explained by the in-image assistant.
I am the concrete `PulsarLLMAgent` strategy for **debugger** entities: I take the
debugger model of the stack presenter and wire it to the explain-only agent
presenter, so the entity's own agent model supplies the stack-specific prompt.

## Responsibilities
- I am the assistant entry point for a debug stack.
- I provide the presenter used to display the assistant for that stack.
- I delegate the choice of agent model to the debugger model I am built on.

## Collaborators
- **PulsarLLMAgent** — my abstract superclass; provides lifecycle and the popup.
- **PulsarLLMDebugAgentModel** — the debug-specific agent model with the explain prompt.
- **PulsarLLMDebugAgentPresenter** — the explain-only popover UI.
- **PulsarDebuggerModel** — the entity that creates me (via `newAgentModel`).

## Example
`PulsarContextStackPresenter>>defineAgentActionsOn:` builds me with
`PulsarLLMDebugAgent newModel: self model callerAction: action callerPresenter: self`
and sends me `show`.
"
Class {
	#name : 'PulsarLLMDebugAgent',
	#superclass : 'PulsarLLMAgent',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'as yet undefined' }
PulsarLLMDebugAgent >> newAgentPresenter [
	"Answer a new agent presenter instantiated by my caller presenter and wired to my model."

	^ self callerPresenter 
		instantiate: PulsarLLMDebugAgentPresenter 
		on: self model newAgentModel
]
