"
# PulsarLLMRepositoryAgent

I bind a repository diff to the Pulsar LLM assistant.

## Why I exist
Working-copy changes and commits can be explained by the in-image assistant.
I am the concrete `PulsarLLMAgent` strategy for **repository diff** entities: I take the
diff node selected in the diff editor and wire it to the explain-only agent presenter,
so the node's own agent model supplies the diff-specific prompt.

## Responsibilities
- I am the assistant entry point for a repository diff node.
- I provide the presenter used to display the assistant for that diff.
- I delegate the choice of agent model to the diff node I am built on.

## Collaborators
- **PulsarLLMAgent** — my abstract superclass; provides lifecycle and the popup.
- **PulsarLLMRepositoryAgentModel** — the diff-specific agent model with the explain prompt.
- **PulsarLLMRepositoryAgentPresenter** — the explain-only popover UI.
- **PulsarRepositoryDiffEditor** — the view that creates me through `defineAgentActionsOn:`.
"
Class {
	#name : 'PulsarLLMRepositoryAgent',
	#superclass : 'PulsarLLMAgent',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'accessing' }
PulsarLLMRepositoryAgent >> newAgentPresenter [
	"Answer a new agent presenter instantiated by my caller presenter and wired to my model."

	^ self callerPresenter instantiate: PulsarLLMRepositoryAgentPresenter on: self model newAgentModel
]
