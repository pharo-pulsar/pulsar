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
		'markdown'
	],
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'constants' }
PulsarLLMAgentStreamStyler class >> defaultPalette [
	"256-color indices approximating the OpenCode TUI (glamour) theme."

	^ Dictionary new
		  at: #text put: 252;
		  at: #reasoning put: 245;
		  at: #tool put: 74;
		  at: #step put: 240;
		  at: #error put: 203;
		  at: #code put: 252;
		  at: #codeBackground put: 236;
		  at: #heading put: 81;
		  at: #link put: 39;
		  at: #bullet put: 74;
		  at: #listMarker put: 74;
		  at: #quote put: 244;
		  at: #rule put: 240;
		  yourself
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
PulsarLLMAgentStreamStyler >> format: aChunk kind: aKind [
	"Answer the ANSI rendering of aChunk for aKind, or plain text when colors are off."

	(aChunk isNil or: [ aChunk isEmpty ]) ifTrue: [ ^ '' ].
	colored ifFalse: [ ^ self plainFormat: aChunk kind: aKind ].
	^ (self styledChunk: aChunk kind: aKind) , ansi reset
]

{ #category : 'initialize' }
PulsarLLMAgentStreamStyler >> initialize [

	colored := true.
	ansi := PulsarLLMAnsiWriter new.
	palette := self class defaultPalette.
	markdown := PulsarLLMMarkdownStyler new.
	markdown ansi: ansi.
	markdown palette: palette.
	super initialize
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
