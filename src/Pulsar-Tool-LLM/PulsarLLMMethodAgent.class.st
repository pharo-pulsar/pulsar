"
# PulsarLLMMethodAgent

I bind a method to the Pulsar LLM assistant.

## Why I exist

Methods can be explained or commented by the in-image assistant, just like classes.
I am the concrete `PulsarLLMAgent` strategy for **method** entities: I take the method
model of the calling editor and wire it to the shared agent presenter, so the
entity's own agent model supplies the method-specific prompts.

## Responsibilities

- I am the assistant entry point for a method.
- I provide the presenter used to display the assistant for that method.
- I delegate the choice of agent model to the method I am built on.

## Collaborators

- **PulsarLLMAgent** — my abstract superclass; provides lifecycle and the popup.
- **PulsarLLMMethodAgentModel** — the method-specific agent model with the explain/comment prompts.
- **PulsarLLMAgentPresenter** — the popover UI shared by all agents.
- **PvMethodModel** — the entity that creates me (via `newAgentModel`).

## Example

`PvMethodModel>>defineAgentActionsOn:` builds me with
`PulsarLLMMethodAgent newModel: self callerAction: action callerPresenter: aContext`
and sends me `show`.
"
Class {
	#name : 'PulsarLLMMethodAgent',
	#superclass : 'PulsarLLMAgent',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}
