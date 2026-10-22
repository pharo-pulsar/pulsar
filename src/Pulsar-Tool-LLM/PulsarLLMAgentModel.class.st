"
I represent a Pulsar LLM agent: a conversational assistant bound to a single Pulsar entity (a class, method, debugger, or repository).

I am the abstract base for the concrete agents in the `Agent` tag. I know how to open and reuse an LLM session for the entity I am attached to, stream the model's answer back chunk by chunk so it can be shown live, and keep the session until my editor is closed. The actual prompt is my subclasses' responsibility, so I stay independent of *what* is being explained or commented.

My main collaborators are:

- my subclasses (`PulsarLLMClassAgentModel`, `PulsarLLMMethodAgentModel`, `PulsarLLMDebugAgentModel`, `PulsarLLMRepositoryAgentModel`), which define the concrete `commentPrompt` and `explainPrompt`.
- `PulsarLLMAgentPresenter`, which triggers `explainOn:` / `commentOn:` and renders each streamed chunk through `feed:kind:`.
- `PulsarLLMChatConsole`, whose selected LLM determines the API used to create new agent sessions.

## Public API and key messages
- `explainOn: aPresenter` / `commentOn: aPresenter` — run the agent and stream the answer into the presenter.
- `closeSession` — release the LLM session, e.g. when the editor closes.
- `title`, `iconName`, `fullName` — identity of the agent and its entity.
- `commentPrompt` / `explainPrompt` — abstract; subclasses must implement.
- `on: aModel` creates an agent for a model (see example).

## Example
```smalltalk
PulsarLLMClassAgentModel on: aClassModel
```

## References
- `PvBaseModel` — superclass, provides `entity`, `environmentModel`, and the model protocol.
- `PulsarLLMAgentPresenter` — the view that hosts and drives agents.
"
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
PulsarLLMAgentModel >> actionsWithContextOn: aContextPresenter [

	^ (self actions actionsFor: #toolbar) copyWithContext: aContextPresenter
]

{ #category : 'testing' }
PulsarLLMAgentModel >> canComment [

	^ true
]

{ #category : 'actions' }
PulsarLLMAgentModel >> cancelQuery [

	session ifNil: [ ^ self ].

	session abort
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

{ #category : 'private - definitions' }
PulsarLLMAgentModel >> defineCancelActionOn: aBuilder [

	<dockActions>
	aBuilder addGroup: #toolbar with: [ :group |
			group addActionWith: [ :action |
					action
						priority: 50;
						name: 'Cancel';
						iconName: 'stop';
						description: 'Cancel the ongoing inference';
						actionEnabled: [ :aPresenter | aPresenter isQuerying ];
						action: [ :aPresenter | aPresenter cancelQuery ] ] ]
]

{ #category : 'private - definitions' }
PulsarLLMAgentModel >> defineCommentActionsOn: aBuilder [
	<dockActions>
	
	self canComment ifFalse: [ ^ self ].
	
	aBuilder addGroup: #toolbar with: [ :group | group
		addActionWith: [ :action | action
			priority: 100;
			name: 'Comment';
			iconName: 'comment';
			description: f'Add a comment to [self fullName]';
			action: [ :aPresenter | aPresenter doComment ] ];
		addActionWith: [ :action | action
			priority: 100;
			name: 'Update comment';
			iconName: 'updateComment';
			description: f'Update [self fullName] comment';
			action: [ :aPresenter | aPresenter doComment ] ] ]
]

{ #category : 'private - definitions' }
PulsarLLMAgentModel >> defineExplainActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #toolbar with: [ :group | group 
		addActionWith: [ :action | action
			priority: 1;
			name: 'Explain';
			iconName: 'explain';
			description: f'Attempt to put [self fullName] in context to provide a better understanding of it';
			action: [ :aPresenter | aPresenter doExplain ] ] ]
]

{ #category : 'private' }
PulsarLLMAgentModel >> ensureSessionOn: anApplication [

	^ session ifNil: [
			  | modelClass |
			  modelClass := PulsarLLMModel findAgentNamed: anApplication settings agentName.
			  session := (modelClass newAPIOn: anApplication) newSession ]
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

{ #category : 'private - prompts' }
PulsarLLMAgentModel >> updateCommentPrompt [

	^ self subclassResponsibility
]
