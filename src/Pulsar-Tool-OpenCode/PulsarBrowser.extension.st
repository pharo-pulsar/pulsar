Extension { #name : 'PulsarBrowser' }

{ #category : '*Pulsar-Tool-OpenCode' }
PulsarBrowser >> defineOpenCodeExtraActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #tools with: [ :group | group 
		addActionWith: [ :action | action 
			priority: 1000;
			name: 'Open LLM Chat Console';
			description: 'Open a LLM chat console';
			action: [ self addUniquePresenterClass: PulsarLLMChatConsole  ] 
		]
	]
]
