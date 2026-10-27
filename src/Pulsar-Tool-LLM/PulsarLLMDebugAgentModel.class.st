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
explain the debug stack in the debugger open with title "[self fullName]".

**Goal:** Help a Smalltalk programmer understand what is happening, how execution reached this point, and why it stopped.

**Output:**
- **Situation:** Briefly explain what the system was trying to do when execution stopped.
- **Execution flow:** Reconstruct the relevant sequence of calls, focusing on the meaningful frames rather than listing the entire stack.
- **Likely cause:** Explain why execution stopped, distinguishing the immediate failure from its possible underlying cause.
- **Next step:** Suggest the most useful thing to inspect next, only if the cause remains unclear.

**Constraints:**
- Maximum 200 words.
- Focus on causal relationships, not frame-by-frame descriptions.
- Prioritize application code over framework and debugger infrastructure.
- Don''t assume the top frame is the root cause.
- Distinguish observed facts from hypotheses.
- Don''t speculate beyond the available evidence.
- Don''t perform a general code review or suggest refactorings.
- Omit sections that add no useful information.
- Return only the explanation.

Skip any image save & backup phase.
Skip any learning phase.'
]
