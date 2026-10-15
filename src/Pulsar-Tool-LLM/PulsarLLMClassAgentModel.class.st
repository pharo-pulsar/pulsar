"
I am the model of a LLM agent working on a class (PvClassModel) in the Pulsar class editor.

I provide the class-specific prompts (explain, comment) consumed by a PulsarLLMAgentPresenter. Session management and streaming come from PulsarLLMAgentModel.
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
add a comment (do not save) to the class editor [self fullName].
be concise: what the class (or trait) does and why it exists and not *how* it does it unless this is really useful.
use markdown to comment.
suggested template:
For the Class part: State a one line summary. For example, "I represent a paragraph of text".
For the Responsibility part: Three sentences about main responsibilities - what I do, what I know.
For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- how to create instances.

Consider adding one simple example.
Consider adding one or more usage references. 

Skip any image save & backup phase.
Skip any learning phase.'
]

{ #category : 'accessing' }
PulsarLLMClassAgentModel >> explainPrompt [
	<pulsarSourceEditor: 'markdown'>
	
	^ f'using pulsar
explain the class [self fullName].
explanation must contain what the class does in the context of its package and hierarchy
explanation can contain also
- its responsibilities
- its main collaborators
- how it relates to its superclass and subclasses
- some example on how and where the class is being used.

Skip any image save & backup phase.
Skip any learning phase.'
]
