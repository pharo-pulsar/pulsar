Class {
	#name : 'PulsarLLMMethodAgent',
	#superclass : 'PulsarLLMAgent',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'private' }
PulsarLLMMethodAgent >> newAgentPresenter [
	"Answer a new agent presenter instantiated by my caller presenter and wired to my model."

	^ self callerPresenter 
		instantiate: PulsarLLMAgentPresenter
		on: self model newAgentModel
]
