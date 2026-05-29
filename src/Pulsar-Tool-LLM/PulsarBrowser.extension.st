Extension { #name : 'PulsarBrowser' }

{ #category : '*Pulsar-Tool-LLM' }
PulsarBrowser >> defineOpenCodeExtraActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #tools with: [ :group | group 
		addActionWith: [ :action | action 
			priority: 1000;
			name: 'Open LLM Chat Console';
			description: 'Open a LLM chat console';
			actionVisible: [ self application settings isFeatureEnabled: #llm ];
			action: [ self addUniquePresenterClass: PulsarLLMChatConsole  ] 
		]
	]
]
