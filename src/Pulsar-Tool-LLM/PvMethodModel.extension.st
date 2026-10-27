Extension { #name : 'PvMethodModel' }

{ #category : '*Pulsar-Tool-LLM' }
PvMethodModel >> defineAgentActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: #decoration with: [ :group |
			| agentModel agentActions |
			agentModel := self newAgentModel.
			agentActions := agentModel actions actionsFor: #toolbar.
			agentActions entries do: [ :each | each actionVisible: [ :aContext | aContext application settings isFeatureEnabled: #llm ] ].
			group addGroupWith: [ :agentGroup |
					agentGroup
						name: 'Agent';
						description: f'Agent actions on [self name]';
						iconName: 'agent';
						beToolbarMenuButton;
						addAll: agentActions entries ] ]
]

{ #category : '*Pulsar-Tool-LLM' }
PvMethodModel >> newAgentModel [

	^ PulsarLLMMethodAgentModel on: self
]
