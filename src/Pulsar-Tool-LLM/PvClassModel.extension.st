Extension { #name : 'PvClassModel' }

{ #category : '*Pulsar-Tool-LLM' }
PvClassModel >> defineAgentActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: #decoration with: [ :group |
			group addActionWith: [ :action |
					action
						name: 'Agent';
						description: f'Agent actions on [self name]';
						iconName: 'agent';
						actionVisible: [ :aContext | aContext application settings isFeatureEnabled: #llm ];
						action: [ :aContext | (PulsarLLMAgent newModel: self callerAction: action callerPresenter: aContext) show ] ] ]
]

{ #category : '*Pulsar-Tool-LLM' }
PvClassModel >> newAgentModel [

	^ PulsarLLMClassAgentModel on: self
]
