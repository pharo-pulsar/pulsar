Extension { #name : 'PulsarBrowser' }

{ #category : '*Pulsar-Tool-LLM' }
PulsarBrowser >> defineLLMActionsOn: aBuilder [
	<dockActions>
	
	| availableModels usingLLM|
	
	
	usingLLM := PulsarLLMModel findAgentNamed: self application settings agentName.
	
	aBuilder addGroup: #llm with: [ :group | group 
		priority: 1000;
		name: 'Assistant';
		beDisplayedAsSubMenu;
		addActionWith: [ :action | action
			dynamicName: [ f'New [usingLLM label] Terminal' ];
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
					ifFalse: [ PulsarLLMSharedMCPServer default ensureStarted ] ] ]. 
	
		availableModels := PulsarLLMModel allModels.
		availableModels size > 1 ifTrue: [
			group addGroup: #specificModels with: [ :moreGroup | moreGroup
				beDisplayedAsSubMenu;
				name: 'More';
				description: 'Open a specific available agent (if more than just one available)'.
				
				availableModels 
					reject: [ :each | each = usingLLM ]; 
					do: [ :each | 
						moreGroup addActionWith: [ :action | action 
							name: f'New [each label] Terminal';
							description: 'Open a new terminal for the selected LLM client';
							actionVisible: [ self application settings isFeatureEnabled: #llm ];
							action: [ 
								self notificationCenter announce: (PulsarRequestNewLLMTerminal new
									model: (PulsarLLMChatConsoleModel new 
										clientClass: each;
										yourself);
									yourself) ]
					]
				] 
			] 
		] 
	]
]
