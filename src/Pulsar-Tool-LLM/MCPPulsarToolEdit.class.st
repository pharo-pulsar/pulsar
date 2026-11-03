"
I am an abstract MCP tool for editing content that is currently open in a Pulsar editor.

I resolve the target editor across the open Pulsar browsers, the main browser first, then any other browser. My concrete subclasses define the actual edit operations, for example MCPPulsarMethodEdit for method editors, and inherit browser enumeration and GTK main-loop marshalling from MCPPulsarTool.

"
Class {
	#name : 'MCPPulsarToolEdit',
	#superclass : 'MCPPulsarTool',
	#category : 'Pulsar-Tool-LLM-MCP-Tools',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'MCP-Tools'
}

{ #category : 'testing' }
MCPPulsarToolEdit class >> isAbstract [

	^ self = MCPPulsarToolEdit
]

{ #category : 'accessing' }
MCPPulsarToolEdit >> editorMatchingModelFullName: aString [
	"Answer the first open editor whose model full name matches aString, or nil."

	| wanted |
	aString ifNil: [ ^ nil ].
	wanted := aString asString.
	(wanted beginsWith: '#') ifTrue: [ wanted := wanted allButFirst ].
	self openEditors do: [ :eachEditor |
			| model |
			model := eachEditor model.
			(model notNil and: [ (model respondsTo: #fullName) and: [ model fullName = wanted ] ]) ifTrue: [ ^ eachEditor ] ].
	^ nil
]

{ #category : 'accessing' }
MCPPulsarToolEdit >> openEditors [
	"Answer the editor presenters of every open Pulsar browser, main browser first."

	^ self pulsarBrowsers flatCollect: [ :eachBrowser | eachBrowser editors collect: [ :eachPanel | eachPanel presenter ] ]
]
