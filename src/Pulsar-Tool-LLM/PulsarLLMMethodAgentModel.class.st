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
	
	^ f'using pulsar
add a comment (do not save) to the editor [self fullName].
concise, what he does and not *how* it does it unless this is really useful

Skip any image save & backup phase.
Skip any learning phase.'
]

{ #category : 'private - prompts' }
PulsarLLMMethodAgentModel >> explainPrompt [
	<pulsarSourceEditor: 'markdown'>

	^ f'using pulsar
explain the method [self fullName].
explanation must contain what the method does in the context of the class
explanation can contain also
- answer type (self or type)
- type of arguments expected  
- constraints to use it
- some example on how and where the method is being used.

Skip any image save & backup phase.
Skip any learning phase.'
]
