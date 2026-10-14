"
# PulsarLLMDebugAgentModel

I am the model of a LLM agent working on a debug stack (PulsarDebuggerModel) in the Pulsar debugger.

## Why I exist
Debug stacks can be explained by the in-image assistant (commenting makes no sense for a stack).
I am the concrete `PulsarLLMAgentModel` strategy for **debugger** entities: I wrap the
debugger model and supply the stack-specific explain prompt.

## Responsibilities
- I provide the explain prompt for the debug stack.
- I delegate session management and streaming to `PulsarLLMAgentModel`.

## Collaborators
- **PulsarLLMAgentModel** — my superclass; provides the session and streaming.
- **PulsarLLMDebugAgentPresenter** — the explain-only popover UI that consumes my prompt.
- **PulsarDebuggerModel** — the entity I wrap (the session name is my `fullName`).

## Example
`PulsarDebuggerModel>>newAgentModel` answers `PulsarLLMDebugAgentModel on: self`.
"
Class {
	#name : 'PulsarLLMDebugAgentModel',
	#superclass : 'PulsarLLMAgentModel',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'accessing' }
PulsarLLMDebugAgentModel >> explainPrompt [
	<pulsarSourceEditor: 'markdown'>
	
	^ f'using pulsar
explain the debug stack [self fullName].
explanation must contain what is happening: the condition raised and the call chain leading to it
explanation can contain also
- the likely cause of the failure
- which stack frames are most relevant to investigate
- suggested next steps to fix it.

Skip any image save & backup phase.
Skip any learning phase.'
]
