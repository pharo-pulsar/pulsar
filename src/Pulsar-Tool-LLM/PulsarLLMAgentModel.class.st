Class {
	#name : 'PulsarLLMAgentModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'session'
	],
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'instance creation' }
PulsarLLMAgentModel class >> on: aModel [

	^ self newEnvironment: aModel environmentModel entity: aModel
]

{ #category : 'actions' }
PulsarLLMAgentModel >> closeSession [

	session ifNil: [ ^ self ].

	session delete.
	session := nil
]

{ #category : 'actions' }
PulsarLLMAgentModel >> commentOn: anAgentPresenter [
	"Ask the session for a comment and stream the response into the presenter."

	self ensureSessionOn: anAgentPresenter application.
	self session 
		query: self commentPrompt 
		do: [ :chunk :kind | anAgentPresenter feed: chunk kind: kind ]
]

{ #category : 'private - prompts' }
PulsarLLMAgentModel >> commentPrompt [

	^ self subclassResponsibility
]

{ #category : 'private' }
PulsarLLMAgentModel >> ensureSessionOn: anApplication [

	self flag: #TODO. "This has to come from application, as there can be other agents"
	^ session ifNil: [ 
		session := PulsarLLMOpenCodeAPI new 
			model: 'litellm/deepseek-flash';
			newSession ]
]

{ #category : 'accessing' }
PulsarLLMAgentModel >> entity [
	"entity in this case is another model (class/method/etc)"

	^ entity
]

{ #category : 'initialization' }
PulsarLLMAgentModel >> entity: aModel [
	"entity in this case is another model (class/method/etc)"

	entity := aModel
]

{ #category : 'actions' }
PulsarLLMAgentModel >> explainOn: anAgentPresenter [

	self ensureSessionOn: anAgentPresenter application.
	anAgentPresenter resetStream.
	self session query: self explainPrompt do: [ :chunk :kind | anAgentPresenter feed: chunk kind: kind ]
]

{ #category : 'private - prompts' }
PulsarLLMAgentModel >> explainPrompt [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
PulsarLLMAgentModel >> fullName [

	^ self entity fullName
]

{ #category : 'testing' }
PulsarLLMAgentModel >> hasPulsarEditor [

	^ self pulsarEditorClass isNotNil
]

{ #category : 'accessing - ui' }
PulsarLLMAgentModel >> iconName [

	^ 'agent'
]

{ #category : 'accessing' }
PulsarLLMAgentModel >> pulsarEditorClass [

	^ PulsarLLMAgentPresenter
]

{ #category : 'accessing' }
PulsarLLMAgentModel >> session [

	^ session
]

{ #category : 'accessing' }
PulsarLLMAgentModel >> title [

	^ f'Assistant on: [self entity title]'
]
