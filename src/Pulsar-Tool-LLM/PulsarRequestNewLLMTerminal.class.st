"
I request a new LLM terminal panel. Unlike the old assistant console toggle, every request creates a new panel, so several agent terminals can coexist.
"
Class {
	#name : 'PulsarRequestNewLLMTerminal',
	#superclass : 'PulsarRequestToolAnnouncement',
	#instVars : [
		'unique'
	],
	#category : 'Pulsar-Tool-LLM-Announcement',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Announcement'
}

{ #category : 'accessing' }
PulsarRequestNewLLMTerminal >> beNotUnique [

	unique := false
]

{ #category : 'accessing' }
PulsarRequestNewLLMTerminal >> beUnique [

	unique := true
]

{ #category : 'initialization' }
PulsarRequestNewLLMTerminal >> initialize [

	unique := false.
	super initialize
]

{ #category : 'testing' }
PulsarRequestNewLLMTerminal >> isUnique [

	^ unique
]

{ #category : 'accessing' }
PulsarRequestNewLLMTerminal >> toolClass [

	^ PulsarLLMChatConsole
]
