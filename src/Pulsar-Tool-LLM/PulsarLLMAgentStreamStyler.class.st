"
I turn streamed agent chunks into ANSI-styled text for the Pulsar terminal, approximating the OpenCode TUI look.

I dispatch on the chunk kind (#text, #reasoning, #tool, #step, #error), delegating markdown rendering to PulsarLLMMarkdownStyler. When my #colored flag is false I answer plain text instead, so output can be logged or tested without escape sequences.
"
Class {
	#name : 'PulsarLLMAgentStreamStyler',
	#superclass : 'Object',
	#instVars : [
		'colored',
		'ansi',
		'palette',
		'markdown',
		'reasoningHeaderSent',
		'lastKind',
		'lastEndedNewline'
	],
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'private' }
PulsarLLMAgentStreamStyler class >> defaultPalette [
	"Answer the 256-color palette used by the agent stream styler."

	^ Dictionary newFromPairs:
		  #( 'text' 252 'reasoning' 245 'tool' 74 'step' 240 'error' 203 'code' 252 'codeBackground' 236 'heading' 140 'link' 39 'bullet'
		     74 'listMarker' 74 'quote' 244 'rule' 240 )
]

{ #category : 'private' }
PulsarLLMAgentStreamStyler >> colorAt: aSymbol [

	^ palette at: aSymbol ifAbsent: [ 252 ]
]

{ #category : 'accessing' }
PulsarLLMAgentStreamStyler >> colored [

	^ colored
]

{ #category : 'accessing' }
PulsarLLMAgentStreamStyler >> colored: anObject [

	colored := anObject
]

{ #category : 'formatting' }
PulsarLLMAgentStreamStyler >> endsWithVisibleNewline: aString [
	"Answer whether the last character of aString outside ANSI escapes is a line break."

	| last inEscape |
	last := nil.
	inEscape := false.
	aString do: [ :each |
			each = Character escape
				ifTrue: [ inEscape := true ]
				ifFalse: [
						inEscape
							ifTrue: [ inEscape := each ~= $m ]
							ifFalse: [ last := each ] ] ].
	^ last notNil and: [ last = Character cr or: [ last = Character lf ] ]
]

{ #category : 'formatting' }
PulsarLLMAgentStreamStyler >> format: aChunk kind: aKind [
	"Answer the ANSI rendering of aChunk for aKind, or plain text when colors are off.

	A kind change that happens mid-line is separated by a line break."

	| header body prefix result |
	(aChunk isNil or: [ aChunk isEmpty ]) ifTrue: [ ^ '' ].
	prefix := self kindBoundaryPrefix: aKind.
	header := aKind = #reasoning
		          ifTrue: [ self takeReasoningHeader ]
		          ifFalse: [ '' ].
	colored
		ifTrue: [ body := (self styledChunk: aChunk kind: aKind) , ansi reset ]
		ifFalse: [ body := self plainFormat: aChunk kind: aKind ].
	result := prefix , header , body.
	lastKind := aKind.
	result ifNotEmpty: [ lastEndedNewline := self endsWithVisibleNewline: result ].
	^ result
]

{ #category : 'initialize' }
PulsarLLMAgentStreamStyler >> initialize [

	colored := true.
	ansi := PulsarLLMAnsiWriter new.
	palette := self class defaultPalette.
	markdown := PulsarLLMMarkdownStyler new.
	markdown ansi: ansi.
	markdown palette: palette.
	reasoningHeaderSent := false.
	lastKind := nil.
	lastEndedNewline := true.
	super initialize
]

{ #category : 'formatting' }
PulsarLLMAgentStreamStyler >> kindBoundaryPrefix: aKind [
	"Answer a leading line break when aKind follows a different kind mid-line, and
	forget incremental markdown state at every kind change."

	| changed |
	lastKind ifNil: [ ^ '' ].
	changed := lastKind ~= aKind.
	changed ifFalse: [ ^ '' ].
	markdown reset.
	^ lastEndedNewline
		  ifTrue: [ '' ]
		  ifFalse: [ String cr ]
]

{ #category : 'accessing' }
PulsarLLMAgentStreamStyler >> palette: anObject [

	palette := anObject.
	markdown palette: anObject
]

{ #category : 'private' }
PulsarLLMAgentStreamStyler >> plainFormat: aChunk kind: aKind [

	(aKind = #text or: [ aKind = #reasoning ]) ifTrue: [ ^ markdown stripMarkdown: aChunk ].
	^ aChunk
]

{ #category : 'private' }
PulsarLLMAgentStreamStyler >> styledChunk: aChunk kind: aKind [

	aKind = #text ifTrue: [ ^ markdown format: aChunk ].
	aKind = #reasoning ifTrue: [ ^ (ansi color: (self colorAt: #reasoning)) , ansi dim , aChunk ].
	aKind = #tool ifTrue: [ ^ (ansi color: (self colorAt: #tool)) , aChunk ].
	aKind = #step ifTrue: [ ^ (ansi color: (self colorAt: #step)) , aChunk ].
	aKind = #error ifTrue: [ ^ ansi bold , (ansi color: (self colorAt: #error)) , aChunk ].
	^ aChunk
]

{ #category : 'private' }
PulsarLLMAgentStreamStyler >> takeReasoningHeader [
	"Answer the dim opencode-style thinking header once per query, or an empty string after that."

	reasoningHeaderSent ifTrue: [ ^ '' ].
	reasoningHeaderSent := true.
	^ colored
		  ifTrue: [ (ansi color: (self colorAt: #reasoning)) , ansi dim , '⋯ Thinking' , ansi reset , String cr ]
		  ifFalse: [ '⋯ Thinking' , String cr ]
]
