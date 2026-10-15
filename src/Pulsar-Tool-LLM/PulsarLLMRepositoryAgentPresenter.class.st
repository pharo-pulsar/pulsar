"
# PulsarLLMRepositoryAgentPresenter

I am the popover UI of the LLM agent for repository diffs.

## Why I exist
Diffs can be explained but not commented, so unlike the method and class agents I hide the Comment action and only offer Explain.

## Responsibilities
- I present the streamed answer for a working copy or commit diff.
- I suppress the Comment action.

## Collaborators
- **PulsarLLMAgentPresenter** — my superclass; provides the terminal, toolbar and streaming display.
- **PulsarLLMRepositoryAgentModel** — the model whose explain prompt I trigger.
"
Class {
	#name : 'PulsarLLMRepositoryAgentPresenter',
	#superclass : 'PulsarLLMAgentPresenter',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'accessing' }
PulsarLLMRepositoryAgentPresenter >> showsCommentAction [

	^ false
]
