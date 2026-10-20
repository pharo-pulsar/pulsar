Class {
	#name : 'PulsarLLMAgentSession',
	#superclass : 'Object',
	#instVars : [
		'api',
		'sessionId'
	],
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'instance creation' }
PulsarLLMAgentSession class >> on: anApi [

	^ self new 
		api: anApi;
		yourself
]

{ #category : 'submorphs - add/remove' }
PulsarLLMAgentSession >> abort [

	sessionId ifNil: [ ^ self ].

	api abortSession: sessionId
]

{ #category : 'accessing' }
PulsarLLMAgentSession >> api [

	^ api
]

{ #category : 'initialization' }
PulsarLLMAgentSession >> api: anAPI [

	api := anAPI
]

{ #category : 'submorphs - add/remove' }
PulsarLLMAgentSession >> delete [

	sessionId ifNil: [ ^ self ].
	
	api deleteSession: sessionId.
	sessionId := nil
]

{ #category : 'private' }
PulsarLLMAgentSession >> ensureSession [

	^ sessionId ifNil: [ sessionId := (api createSession: 'Pharo Agent Session') at: 'id' ]
]

{ #category : 'accessing' }
PulsarLLMAgentSession >> query: aString [

	self ensureSession.
	^ api answerTextFrom: (api sendText: aString toSession: sessionId)
]

{ #category : 'accessing' }
PulsarLLMAgentSession >> query: aString do: aBlock [
	"Stream the answer to aString, feeding each chunk and its kind to aBlock.
	 Answers the complete text."

	self ensureSession.
	^ api sendText: aString toSession: sessionId do: aBlock
]

{ #category : 'accessing' }
PulsarLLMAgentSession >> query: aString kinds: aCollection do: aBlock [
	"Stream the answer to aString, restricted to aCollection of kinds, feeding each
	 chunk and its kind to aBlock. Answers the complete text."

	self ensureSession.
	^ api
		  sendText: aString
		  toSession: sessionId
		  kinds: aCollection
		  do: aBlock
]
