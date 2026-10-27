Extension { #name : 'PulsarBrowser' }

{ #category : '*Pulsar-Tool-LLM' }
PulsarBrowser >> defineLLMActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #tools with: [ :group | group
		addGroup: #llm with: [ :llmGroup | llmGroup 
			priority: 1000;
			name: 'Assistant';
			beDisplayedAsSubMenu;
			addActionWith: [ :action | action
				name: 'New Agent Terminal';
				description: 'Open a new terminal for the selected LLM client';
				actionVisible: [ self application settings isFeatureEnabled: #llm ];
				action: [
					self notificationCenter announce: (PulsarRequestNewLLMTerminal new) ] ];
			addActionWith: [ :action | action
				name: 'MCP Server';
				description: 'Toggle MCP server activation';
				actionVisible: [ self application settings isFeatureEnabled: #llm ];
				actionState: [ PulsarLLMSharedMCPServer default isRunning  ];
				action: [ 
					PulsarLLMSharedMCPServer default isRunning 
						ifTrue: [ PulsarLLMSharedMCPServer default stop ]
						ifFalse: [ PulsarLLMSharedMCPServer default ensureStarted ] ] ] ] ]
]
