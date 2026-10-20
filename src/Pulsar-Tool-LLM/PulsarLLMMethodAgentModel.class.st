Class {
	#name : 'PulsarLLMMethodAgentModel',
	#superclass : 'PulsarLLMAgentModel',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'private - prompts' }
PulsarLLMMethodAgentModel >> commentPrompt [

	<pulsarSourceEditor: 'markdown'>
	<pulsarLLMEffor: 'immediate'>
	^ f'using pulsar
Write a Pharo method comment for the method at the editor [self fullName] (do not save).

**Goal:** Document the method''s behavioral contract and intent, helping a Smalltalk programmer understand why and when to use it.

**Content:**
- Explain what the method accomplishes.
- Clarify non-obvious assumptions, parameters, or return semantics.
- Mention important side effects, preconditions, or exceptional behavior only when relevant.

**Constraints:**
- Maximum 60 words, preferably 1–3 sentences.
- Describe the contract, not the step-by-step implementation.
- Don''t paraphrase the method name or translate statements into prose.
- Don''t explain basic Smalltalk syntax or idioms.
- Don''t document obvious details.
- Don''t invent guarantees unsupported by the code.
- Avoid boilerplate.
- Use clear, natural English.
- Return only the method comment text, without Smalltalk comment delimiters.

Skip any image save & backup phase.
Skip any learning phase.'
]

{ #category : 'private - prompts' }
PulsarLLMMethodAgentModel >> explainPrompt [
	<pulsarSourceEditor: 'markdown'>

	^ f'using pulsar
Explain the method [self fullName].
Explain the following Pharo method.

**Goal:** Help a Smalltalk programmer quickly understand the method''s purpose and behavior.

**Output:**
- **Purpose:** One sentence explaining what the method accomplishes.
- **How:** Briefly explain the essential algorithm or logic.
- **Effects:** Mention important state changes, return values, or exceptional behavior only when relevant.

**Constraints:**
- Maximum 100 words.
- Focus on semantics, not line-by-line explanations.
- Don''t explain basic Smalltalk syntax or idioms.
- Don''t simply translate the code into prose.
- Don''t speculate beyond the available code.
- Don''t perform code review or suggest improvements.
- Return only the explanation.

Skip any image save & backup phase.
Skip any learning phase.'
]

{ #category : 'private - prompts' }
PulsarLLMMethodAgentModel >> updateCommentPrompt [

	<pulsarSourceEditor: 'markdown'>
	^ f'using pulsar
Verify the existing Pharo method comment for the method at the editor [self fullName] (do not save).
if comment is not there, add it (do not save). 

**Goal:** Document the method''s behavioral contract and intent, helping a Smalltalk programmer understand why and when to use it.

**Content:**
- Explain what the method accomplishes.
- Clarify non-obvious assumptions, parameters, or return semantics.
- Mention important side effects, preconditions, or exceptional behavior only when relevant.

**Constraints:**
- Maximum 60 words, preferably 1–3 sentences.
- Describe the contract, not the step-by-step implementation.
- Don''t paraphrase the method name or translate statements into prose.
- Don''t explain basic Smalltalk syntax or idioms.
- Don''t document obvious details.
- Don''t invent guarantees unsupported by the code.
- Avoid boilerplate.
- Use clear, natural English.
- Return only the method comment text, without Smalltalk comment delimiters.

Skip any image save & backup phase.
Skip any learning phase.

concise, what he does and not *how* it does it unless this is really useful

Skip any image save & backup phase.
Skip any learning phase.'
]
