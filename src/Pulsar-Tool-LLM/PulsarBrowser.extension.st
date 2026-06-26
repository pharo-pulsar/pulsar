Extension { #name : 'PulsarBrowser' }

{ #category : '*Pulsar-Tool-LLM' }
PulsarBrowser >> defineOpenCodeExtraActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #tools with: [ :group | group 
		addActionWith: [ :action | action 
			priority: 1000;
			name: 'LLM Chat Console';
			description: 'Toggle LLM chat console';
			actionVisible: [ self application settings isFeatureEnabled: #llm ];
			actionState: [ self hasPresenterClass: PulsarLLMChatConsole ];
			action: [ 
				self 
					doToggleTool: PulsarLLMChatConsole 
					state: action state ] 
		]
	]
]
