"
I am the abstract base class for LLM integration models in Pulsar.

I define the common protocol for preparing an LLM environment, connecting to it, and disconnecting. Subclasses must implement #prepare, #connectTo:, and #disconnect.

I hold the shared MCP server instance (mcp) that exposes Pharo tools to the LLM, and a connected flag tracking whether a session is active.

I provide reusable utilities for subclasses: #startMCP / #stopMCP to control the MCP server lifecycle, and #ensureAgent to write the AGENTS.md guidance file into the image directory.
"
Class {
	#name : 'PulsarLLMModel',
	#superclass : 'Object',
	#instVars : [
		'mcp',
		'connected'
	],
	#category : 'Pulsar-Tool-LLM-Model',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarLLMModel class >> agentsDefinition [

	^ '# Pharo MCP Guidance

Use the `pharo` MCP server for Pharo and Smalltalk tasks in this workspace.

When a request involves Pharo, prefer MCP tool calls over guessing from memory or inspecting unrelated local files.

Use the `pharo` MCP tools first for:

- counting or listing packages
- browsing classes, methods, and protocols
- reading Pharo-side state that only exists in the running image
- triggering Pharo-side actions that the MCP server already exposes

If a needed answer should come from Pharo, explicitly say you are using the `pharo` MCP server.

If a `pharo` MCP tool fails or returns incomplete data, report the failure clearly instead of inventing the answer.

## How to use me

Remember that the Pharo image must be saved when we finish implementing code or executing heavy scripts.

## Pharo code format guidance

Before writing any Pharo Smalltalk code, always load the pharo-formatting skill:
  skill:name:pharo-formatting

The skill provides formatting rules and conventions for this project.
'
]

{ #category : 'accessing' }
PulsarLLMModel class >> allModels [

	^ self allSubclasses sorted: #label ascending
]

{ #category : 'accessing' }
PulsarLLMModel class >> label [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
PulsarLLMModel class >> mcpPort [

	^ 4000
]

{ #category : 'accessing' }
PulsarLLMModel class >> pharoFormattingSkillDefinition [
	^ '---
name: pharo-formatting
description: Pharo Smalltalk code formatting rules and conventions for Pulsar
version: 1.0
---

# Pharo code format guidance

### General rules

- Prefer smaller, meaningful methods over large nested control blocks.
- Use Tab of size 4 for indentation.
- **One blank line separates the method preamble (comment + variables) from the body.**

### Method structure

Every method body is separated from its preamble by one blank line. The preamble consists of an optional comment followed by optional variable declarations.

**Only add a comment when the method is non-trivial** (simple setters/getters do not need one). The comment should describe **what** the method does, not how. Keep it brief.

**No variables, no comment:**
```
myMethod

    self doSomething.
```

**With variables, no comment:**
```
myMethod
    | variable |

    self doSomething.
```

**With variables and comment:**
```
myMethod
    "Brief description of what this does."
    | variable |

    self doSomething.
```

**With comment, no variables:**
```
myMethod
    "Brief description of what this does."

    self doSomething.
```

### Class comments

Every class must have a descriptive class comment. When using `pharo_edit-class` with `operation=create`, always provide the `classComment` parameter. A good comment describes:

- The class''s single responsibility.
- Its key collaborators and role in the architecture.

```
"This method is a model representing a repository commit in Pulsar.

It wraps an IceCommit entity and provides access to author, diff, 
and repository information for the Pulsar browser UI."
```

### Variable naming

**Use descriptive names.** Never single letters unless the domain meaning is universally known (e.g., `x`, `y`, `z` for 3D coordinates).

| Context | Naming | Example |
|---|---|---|
| Meaning is clear from method name | Meaningful word | `position`, `size` |
| Iterator blocks (e.g., `do:`, `collect:`) | `each` | `collection do: [ :each | each model ]` |
| Iterator disambiguation needed | `each` + meaning suffix | `eachName`, `eachSize` |
| `to:do:` numeric iteration | `index` | `1 to: 10 do: [ :index | ... ]` |

### Argument naming

Follow this decision tree:

1. **Short method** (≤ 5 lines) **and** ≤ 2 arguments → Hungarian-style prefix with `a`:
   - `aString`, `aPoint`, `aCollection`

2. **Long method** (> 5 lines) **or** > 2 arguments → meaning + type compound:
   - `nameString`, `sizePoint`, `modelCollection`

3. **Type is unknown or can be multiple types** → just meaning with `a` prefix:
   - `aName`, `aSize`, `aCollectionOfModels`

### Control blocks: `ifTrue:ifFalse:`

**Decision rule:**

| Condition | Format |
|---|---|
| Single statement in both blocks, total line < 60 chars | Inline |
| Single statement in both blocks, total line ≥ 60 chars | New line for `ifTrue:` and `ifFalse:` |
| Any block has multiple statements | New line for `ifTrue:` and `ifFalse:`, even if the other block has only one statement |

**Always use `ifTrue:ifFalse:` order**, never `ifFalse:ifTrue:`.

**Multi-statement in one block (new-line both):**
```
someBooleanStatement
    ifTrue: [
        self trueStatement1.
        self trueStatement2 ]
    ifFalse: [
        self falseStatement ]
```

**Single control block only (`ifTrue:` or `ifFalse:` without the other):**

| Condition | Format |
|---|---|
| Single statement, total line < 60 chars | Inline: `condition ifTrue: [ ... ]` |
| Single statement, ≥ 60 chars | New line |
| Multiple statements | New line |

```
"Multiple statements:"
condition
    ifTrue: [
        self doStepOne.
        self doStepTwo ]
```

### Chained boolean statements (`and:` / `or:`)

| Condition | Format |
|---|---|
| Single `and:` or `or:`, total line < 60 chars | All on one line |
| Multiple chains or total line ≥ 60 chars | One chain per line |

```
someBooleanCheck
    and: [ otherBooleanCheck
    and: [ anotherBooleanCheck ] ]
```

### Error handling blocks (`on:do:`)

**Variable naming:** Use `e` for errors, `w` for warnings, `n` for notifications.

| Condition | Format |
|---|---|
| Single error-handling statement | Same line as `do:` |
| Multiple error-handling statements | New line for each |

```
[
    self someStatement.
    self otherStatement ]
on: Error
do: [ :e |
    self logError: e.
    self notifyUser ]
```

### Iteration blocks (`whileTrue:`, `whileFalse:`, `timesRepeat:`)

Same formatting rules as single control blocks:

| Condition | Format |
|---|---|
| Single statement, total line < 60 chars | Inline |
| Single statement, ≥ 60 chars | New line |
| Multiple statements | New line |

```
[ queue isNotEmpty ]
    whileTrue: [
        self processNext.
        self updateMetrics ]
```

---

## Summary of decision thresholds

| Rule | Threshold |
|---|---|
| Inline vs. new-line control block | 60 chars |
| Short vs. long method (for argument naming) | 5 lines, 2 arguments |
'
]

{ #category : 'actions' }
PulsarLLMModel >> connectTo: aTerminalPresenter [
	
	self startMCP.
	self performConnectTo: aTerminalPresenter.
	self connected: true
]

{ #category : 'private' }
PulsarLLMModel >> connected: anObject [

	connected := anObject
]

{ #category : 'actions' }
PulsarLLMModel >> disconnect [

	self stopMCP.
	self connected: false
]

{ #category : 'private' }
PulsarLLMModel >> ensureAgent [
	| ref |
	
	ref := FileLocator imageDirectory / 'AGENTS.md'.
	ref exists ifFalse: [ 
		ref writeStreamDo: [ :stream | stream << self class agentsDefinition ] ]
]

{ #category : 'private' }
PulsarLLMModel >> ensureSkill: aName with: aDefinition [
	| skillDir ref |
	
	skillDir := FileLocator imageDirectory / '.agents' / 'skills' / aName.
	skillDir ensureCreateDirectory.

	ref := skillDir / 'SKILL.md'.
	ref exists ifFalse: [ 
		ref writeStreamDo: [ :stream | stream << aDefinition ] ]

]

{ #category : 'private' }
PulsarLLMModel >> ensureSkills [
	
	self ensureSkill: 'pharo-formatting' with: self class pharoFormattingSkillDefinition
]

{ #category : 'initialization' }
PulsarLLMModel >> initialize [

	connected := false.
	super initialize
]

{ #category : 'accessing' }
PulsarLLMModel >> isConnected [

	^ connected
]

{ #category : 'accessing' }
PulsarLLMModel >> name [

	^ self class label
]

{ #category : 'private' }
PulsarLLMModel >> performConnectTo: aTerminalPresenter [

	self subclassResponsibility
]

{ #category : 'actions' }
PulsarLLMModel >> prepare [

	self ensureAgent.
	self ensureSkills
]

{ #category : 'private' }
PulsarLLMModel >> prepareForSnapshot [

	^ self copy reset
]

{ #category : 'private' }
PulsarLLMModel >> reset [

	mcp := nil.
	connected := false
]

{ #category : 'private' }
PulsarLLMModel >> startMCP [

	(mcp isNotNil and: [ mcp isRunning ]) ifTrue: [ ^ self ].

	mcp := MCP new.
	mcp server 
		loggingOff;
		port: self class mcpPort.
	mcp start
]

{ #category : 'private' }
PulsarLLMModel >> stopMCP [

	(mcp isNotNil and: [ mcp isRunning ]) 
		ifTrue: [ mcp stop ]
]
