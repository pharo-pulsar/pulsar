"
I represent a Pulsar LLM agent bound to a single Pulsar entity (a class, method, debugger, or repository).

I am the abstract base for the concrete agents in the Agent tag. I build the Explain, Comment, and Update comment prompts for my entity and contribute actions to the Agent toolbar menu. Selecting an action opens a new LLM terminal with the prompt; I do not own a session and I do not render output.

My main collaborators are:

- my subclasses (`PulsarLLMClassAgentModel`, `PulsarLLMMethodAgentModel`, `PulsarLLMDebugAgentModel`, `PulsarLLMRepositoryAgentModel`), which define the concrete `commentPrompt` and `explainPrompt`;
- `PulsarLLMChatConsole`, which owns the terminal and client process;
- `PulsarLLMChatConsoleModel`, which carries the client, title, and initial prompt for a new terminal.

## Public API and key messages

- `openExplainOn:` / `openCommentOn:` / `openUpdateCommentOn:` — open a terminal with the corresponding prompt.
- `title`, `iconName`, `fullName` — identity of the agent and its entity.
- `commentPrompt` / `explainPrompt` — abstract; subclasses must implement.
- `on: aModel` creates an agent for a model.

## Example

```smalltalk
PulsarLLMClassAgentModel on: aClassModel
```

## References

- `PvBaseModel` — superclass, provides `entity`, `environmentModel`, and the model protocol.
- `PulsarLLMChatConsole` — the terminal panel that runs the selected client.
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

{ #category : 'actions' }
PulsarLLMAgentModel >> defineCommentActionsOn: aBuilder [
	<dockActions>
	
	self canComment ifFalse: [ ^ self ].

	aBuilder addGroup: #toolbar with: [ :group | group
		addActionWith: [ :action | action
			priority: 100;
			name: 'Comment';
			iconName: 'comment';
			description: f'Add a comment to [self fullName]';
			action: [ :aContext | self openCommentOn: aContext ] ] ]
]

{ #category : 'actions' }
PulsarLLMAgentModel >> defineExplainActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: #toolbar with: [ :group |
			group addActionWith: [ :action |
					action
						priority: 1;
						name: 'Explain';
						iconName: 'explain';
						description: f'Attempt to put [self fullName] in context to provide a better understanding of it';
						action: [ :aContext | self openExplainOn: aContext ] ] ]
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

{ #category : 'private' }
PulsarLLMAgentModel >> nameForAgent [

	^ self entity fullName
]

{ #category : 'private' }
PulsarLLMAgentModel >> openCommentOn: aContext [

	self openPrompt: self commentPrompt on: aContext
]

{ #category : 'private' }
PulsarLLMAgentModel >> openExplainOn: aContext [

	self openPrompt: self explainPrompt on: aContext
]

{ #category : 'private' }
PulsarLLMAgentModel >> openPrompt: aString on: aContext [
	| chatModel |
	
	chatModel := PulsarLLMChatConsoleModel new 
		initialPrompt: aString;
		yourself.
	
	aContext notificationCenter announce: (PulsarRequestNewLLMTerminal new
		beUnique; "push to existing tool (if any)"
		model: chatModel;
		yourself)
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

{ #category : 'accessing - ui' }
PulsarLLMAgentModel >> windowTitle [

	^ f'Assistant on [self fullName]' contractTo: 50
]
