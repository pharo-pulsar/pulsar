"
# PulsarLLMDebugAgentModel

I represent the LLM agent bound to a debug stack (`PulsarDebuggerModel`) in the Pulsar debugger.

## Why I exist

A debug stack cannot be *commented*: it can only be *explained*. I am the concrete `PulsarLLMAgentModel` strategy for the debugger, wrapping the debugger and supplying the stack-specific explain prompt while my superclass owns the session and streaming.

## Responsibilities

- I provide the explain prompt that describes what is happening in the stack: the condition raised and the call chain leading to it.
- I report `canComment` as false, so only explanation is offered for a stack.
- I delegate session management and streaming to `PulsarLLMAgentModel`.

## Collaborators

- **PulsarLLMAgentModel** — my superclass; provides the LLM session, streaming, `fullName`, and lifecycle.
- **PulsarLLMAgentPresenter** — the generic flying-window UI that calls `explainOn:` and renders streamed chunks.
- **PulsarDebuggerModel** — the entity I wrap; its `fullName` names my session.

## Public API and key messages

- `explainPrompt` — the debug-stack explain prompt (my main contribution).
- `canComment` — always false for a debug stack.
- `PulsarLLMDebugAgentModel on: aDebuggerModel` — create an agent for a debugger model.

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

{ #category : 'testing' }
PulsarLLMDebugAgentModel >> canComment [

	^ false
]

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
