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
concise, what the class does and why it exists and not *how* it does it unless this is really useful

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
