Extension { #name : 'PulsarDiffNode' }

{ #category : '*Pulsar-Tool-LLM' }
PulsarDiffNode >> newAgentModel [

	^ PulsarLLMRepositoryAgentModel on: self
]
