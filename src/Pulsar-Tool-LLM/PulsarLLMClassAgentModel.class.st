"
I bind the Pulsar assistant to a single class or trait, so the class as a whole — rather than one of its methods — can be explained or given a comment.

My reason to exist is the class-specific part of that conversation: I hold the prompts that tell the model how to introduce a class to a Smalltalk programmer and what a useful class comment contains. Everything mechanical is inherited. `PulsarLLMAgentModel` owns the LLM session and streams the answer, and contributes the Explain and Comment actions to the Agent menu of the class editor and browser. I do not own a session and I do not render output.

My entity is a `PvClassModel`, the model behind both the browser outline and the class editor. The comment prompt has a deliberate effect on the workflow: it instructs the external agent to write the comment into the open class editor and explicitly not save it, so the text stays dirty for the user to review and accept. The explain prompt only produces text in the terminal.

Apart from the entity I wrap, I carry no state; the session materialises in my superclass only when an action runs. Callers get a fresh instance per toolbar action.

## Example

```smalltalk
PulsarLLMClassAgentModel on: aClassModel
```

## References

- `PulsarLLMAgentModel` — my superclass; session, streaming, and the menu actions.
- `PulsarLLMAgentPresenter` — the terminal panel that runs my prompts and shows the answer.
- `PvClassModel` — the class (or trait) model I wrap; `newAgentModel` answers me.
- `PulsarLLMMethodAgentModel` — the equivalent agent for a single method.
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
Only put the text in the open class editor buffer; do not apply it to the class, update the class comment, or save the image.

**Goal:** Document the class so a Smalltalk programmer can quickly understand its purpose, responsibilities, and intended usage.

**Content:**
- Explain what the class represents and why it exists.
- Describe its main responsibilities and important collaborators.
- Mention significant state, invariants, or usage patterns only when relevant.

**Constraints:**
- If comment already exists, update it instead creating from scratch.
- Focus on the abstraction and its intent, not implementation details.
- Don''''t enumerate methods or accessors.
- Don''''t explain Smalltalk fundamentals.
- Don''''t repeat information obvious from the class name.
- Don''''t invent behavior or design intentions unsupported by the code.
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
