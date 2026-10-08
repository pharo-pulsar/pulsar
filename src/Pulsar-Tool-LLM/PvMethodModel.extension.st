Extension { #name : 'PvMethodModel' }

{ #category : '*Pulsar-Tool-LLM' }
PvMethodModel >> defineAgentActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #decoration with: [ :group | group
		addActionWith: [ :action | action 
			name: 'Agent';
			description: (f'Agent actions on [self name]');
			iconName: 'agent';
			actionVisible: [ :aContext | aContext application settings isFeatureEnabled: #llm ];
			action: [ :aContext | 
				(PulsarLLMMethodAgent
					newModel: self
					callerAction: action
					callerPresenter: aContext)
					show ] ] ]
]
