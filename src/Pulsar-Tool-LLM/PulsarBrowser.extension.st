Extension { #name : 'PulsarBrowser' }

{ #category : '*Pulsar-Tool-LLM' }
PulsarBrowser >> defineLLMActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #tools with: [ :group | group 
		addActionWith: [ :action | action
			priority: 1000;
			name: 'New LLM terminal';
			description: 'Open a new terminal for the selected LLM client';
			iconName: 'add';
			actionVisible: [ self application settings isFeatureEnabled: #llm ];
			action: [
				self notificationCenter announce: (PulsarRequestNewLLMTerminal new) ] ] ]
]
