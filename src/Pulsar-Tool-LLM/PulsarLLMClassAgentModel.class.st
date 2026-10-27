"
I am the LLM agent attached to a class in the Pulsar class editor. I supply the class-specific part of an agent: the prompts that ask the model to explain the class, to write its comment, or to update an existing comment. The rest of the agent behaviour, such as opening a session, streaming the answer, and closing the session, is inherited from `PulsarLLMAgentModel`.

My prompts embed the full name of the class and ask the model to place its result in the class editor without saving, so the programmer reviews the comment before accepting it.

## Example

```smalltalk
(PulsarLLMClassAgentModel on: aClassModel)
    commentOn: anAgentPresenter
```

## References

- `PulsarLLMAgentModel`: superclass, providing the session, the streaming, and the toolbar actions that call `explainOn:` and `commentOn:`.
- `PulsarLLMAgentPresenter`: the presenter that hosts the agent and renders the streamed answer.
- `PvBaseModel`: base of all models, from which the agent hierarchy inherits.
"
Class {
	#name : 'PulsarLLMClassAgentModel',
	#superclass : 'PulsarLLMAgentModel',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'accessing' }
PulsarLLMClassAgentModel >> commentPrompt [

	<pulsarSourceEditor: 'markdown'>
	^ f'using pulsar
Write a Pharo class (or trait) comment (do not save) to the class editor [self fullName].

**Goal:** Document the class so a Smalltalk programmer can quickly understand its purpose, responsibilities, and intended usage.

**Content:**
- Explain what the class represents and why it exists.
- Describe its main responsibilities and important collaborators.
- Mention significant state, invariants, or usage patterns only when relevant.

**Constraints:**
- If comment already exists, update it instead creating from scratch.
- Focus on the abstraction and its intent, not implementation details.
- Don''t enumerate methods or accessors.
- Don''t explain Smalltalk fundamentals.
- Don''t repeat information obvious from the class name.
- Don''t invent behavior or design intentions unsupported by the code.
- Avoid boilerplate and unnecessary headings.
- Use clear, natural English.
- Return only the class comment.
- Output is in markdown.

Consider adding one simple example.
Consider adding one or more usage references. 

Skip any image save & backup phase.
Skip any learning phase.'
]

{ #category : 'accessing' }
PulsarLLMClassAgentModel >> explainPrompt [
	<pulsarSourceEditor: 'markdown'>
	
	^ f'using pulsar
Explain the class [self fullName].
**Goal:** Help a Smalltalk programmer quickly understand what the class does, how it works, and how it fits into the system.

**Output:**
- **Purpose:** One sentence describing the class''s main responsibility.
- **Design:** 2–4 concise bullets explaining its key abstractions, state, and behavior.
- **Interactions:** Important collaborators, superclass relationships, or extension points, only when relevant.

**Constraints:**
- Maximum 150 words.
- Focus on semantics and design, not method-by-method descriptions.
- Group related methods into responsibilities.
- Don''t explain Smalltalk language fundamentals.
- Don''t enumerate accessors or trivial methods.
- Don''t speculate beyond the available code.
- Don''t perform unrelated exploration or code review.
- Return only the explanation.

Skip any image save & backup phase.
Skip any learning phase.'
]
