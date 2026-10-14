"
# PulsarLLMDebugAgentPresenter

I am the popover UI of the LLM agent for a debug stack.

## Why I exist
Unlike method and class agents, a debug stack can only be explained (commenting makes no sense).
I am the `PulsarLLMAgentPresenter` variant for **debugger** entities: I show a single
Explain action in my toolbar, streaming the assistant's answer into the terminal.

## Responsibilities
- I provide an explain-only toolbar for the debug stack agent.
- I inherit the streaming terminal and popover controls from `PulsarLLMAgentPresenter`.

## Collaborators
- **PulsarLLMAgentPresenter** — my superclass; provides the layout, terminal and popover.
- **PulsarLLMDebugAgentModel** — my model; supplies the explain prompt and session.

## Example
`PulsarLLMDebugAgent>>newAgentPresenter` instantiates me with
`instantiate: PulsarLLMDebugAgentPresenter on: self model newAgentModel`.
"
Class {
	#name : 'PulsarLLMDebugAgentPresenter',
	#superclass : 'PulsarLLMAgentPresenter',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'accessing' }
PulsarLLMDebugAgentPresenter >> showsCommentAction [

	^ false
]
