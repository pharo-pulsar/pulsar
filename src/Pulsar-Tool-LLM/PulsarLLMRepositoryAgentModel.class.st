"
# PulsarLLMRepositoryAgentModel

I am the model of a LLM agent working on repository diffs (PulsarDiffNode) in the Pulsar repositories tool.

## Why I exist
Working-copy changes and commits can be explained by the in-image assistant (commenting makes no sense for a diff).
I am the concrete `PulsarLLMAgentModel` strategy for **repository diff** entities: I wrap the selected diff node and supply the diff-specific explain prompt, pointing the assistant to the MCP repository tool that can retrieve the actual changes.

## Responsibilities
- I provide the explain prompt for a working copy or commit diff.
- I delegate session management and streaming to `PulsarLLMAgentModel`.

## Collaborators
- **PulsarLLMAgentModel** — my superclass; provides the session and streaming.
- **PulsarLLMRepositoryAgentPresenter** — the explain-only popover UI that consumes my prompt.
- **PulsarDiffNode** — the entity I wrap (the session name is my `fullName`).
- **PulsarRepositoryDiffEditor** — the view whose toolbar hosts me.
"
Class {
	#name : 'PulsarLLMRepositoryAgentModel',
	#superclass : 'PulsarLLMAgentModel',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'instance creation' }
PulsarLLMRepositoryAgentModel class >> on: aDiffNode [
	"Answer an agent model on aDiffNode.

	 Diff nodes are not environment models, so unlike PvMethodModel and friends I do not ask the entity for its environment."

	^ self newEnvironment: PvEnvironmentModel onSystem entity: aDiffNode
]

{ #category : 'testing' }
PulsarLLMRepositoryAgentModel >> canComment [

	^ false
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> commitDescription [

	| commit |
	commit := self commitForExplanation.
	commit ifNil: [ ^ 'unknown' ].
	^ f'[commit shortId] "[self trimmedCommitMessage: commit]"'
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> commitForExplanation [
	"Answer the commit the explained diff is about or compared against, if any."

	| commit root |
	root := self entity root.
	(root respondsTo: #toCommitish) ifFalse: [ ^ nil ].
	commit := root toCommitish.
	(commit isNil or: [ commit isWorkingCopy ]) ifTrue: [ commit := root fromCommit ].
	(commit isNil or: [ commit isWorkingCopy ]) ifTrue: [ ^ nil ].
	"a branch points to its head commit"
	commit isBranch ifTrue: [ commit := commit commit ].
	^ commit
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> commitForExplanationId [

	^ self commitForExplanation ifNil: [ '' ] ifNotNil: [ :commit | commit id asString ]
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> commitRetrievalInstructions [

	^ f'Retrieve the actual changes with the pulsar MCP tool pharo_edit-repository (operation=commitDiff, repositoryName=[self repositoryName], commit=[self commitForExplanationId]) and use the returned entries as the source of truth.[self focusInstructions]'
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> explainPrompt [
	<pulsarSourceEditor: 'markdown'>

	^ f'Using pulsar
Explain [self explanationSubject] in the repository [self repositoryName].
[self retrievalInstructions]

**Goal:** Explain what changed and why it matters, focusing on behavior and intent rather than individual code edits.

**Output:**
- **Summary:** One sentence explaining the overall change.
- **Changes:** 2–4 concise bullets describing the important modifications.
- **Impact:** Mention behavioral changes, API changes, or compatibility implications only when relevant.

**Constraints:**
- Be concise (maximum 120 words).
- Group related modifications; don''t explain every file or hunk.
- Ignore trivial formatting or mechanical changes.
- Don''t speculate about motivations unless supported by the diff.
- Don''t perform additional research or suggest improvements.
- Return only the summary, without introductory text.

Skip any image save & backup phase.
Skip any learning phase.'
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> explanationSubject [

	self isRootSelection ifTrue: [ ^ self rootExplanationSubject ].
	^ 'the changes to ' , self entity name
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> focusInstructions [

	self isRootSelection ifTrue: [ ^ '' ].
	^ f'
Focus the explanation on the entries whose path contains [self nodePath].'
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> isRootSelection [
	"Answer whether the selected diff node is the root of the diff tree (the whole diff)."

	^ self entity parent isNil
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> isWorkingCopyDiff [
	"Answer whether the explained diff compares the working copy with a commit.

	 Depending on who built the diff root, the working copy can be on the from or the to side."

	^ [
		  | root |
		  root := self entity root.
		  (root respondsTo: #fromCommit) and: [
				  (root fromCommit notNil and: [ root fromCommit isWorkingCopy ]) or: [
					  root toCommitish notNil and: [ root toCommitish isWorkingCopy ] ] ] ]
		  on: Error
		  do: [ :e | false ]
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> nodePath [
	"Answer the repository-relative path of the selected diff node."

	^ [ self entity node path pathString ]
		  on: Error
		  do: [ :e | '' ]
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> repositoryName [

	^ self entity repository name
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> retrievalInstructions [

	^ self isWorkingCopyDiff
		  ifTrue: [ self workingCopyRetrievalInstructions ]
		  ifFalse: [ self commitRetrievalInstructions ]
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> rootExplanationSubject [

	self isWorkingCopyDiff ifTrue: [ ^ 'the ongoing (not yet committed) changes in the working copy' ].
	^ 'the changes introduced by commit ' , self commitDescription
]

{ #category : 'accessing' }
PulsarLLMRepositoryAgentModel >> title [

	| subject |
	subject := [ self entity name ]
		           on: Error
		           do: [ :e | '' ].
	subject isEmpty ifTrue: [ subject := self repositoryName ].
	^ f'Assistant on: [subject]'
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> trimmedCommitMessage: aCommit [

	| message |
	message := (aCommit comment ifNil: [ '' ]) trim.
	message size <= 500 ifTrue: [ ^ message ].
	^ (message copyFrom: 1 to: 500) , '...'
]

{ #category : 'prompts' }
PulsarLLMRepositoryAgentModel >> workingCopyRetrievalInstructions [

	^ f'Retrieve the actual changes with the pulsar MCP tool pharo_edit-repository (operation=diff, repositoryName=[self repositoryName], includeContents=true) and use the returned entries as the source of truth.[self focusInstructions]'
]
