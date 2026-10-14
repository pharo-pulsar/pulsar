"
I am the entry point of the LLM agent for class edition.

I wrap a PvClassModel and, when shown, open a PulsarLLMAgentPresenter (backed by a PulsarLLMClassAgentModel) as a popover relative to my caller action in the class editor.
"
Class {
	#name : 'PulsarLLMClassAgent',
	#superclass : 'PulsarLLMAgent',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}
