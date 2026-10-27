Extension { #name : 'PulsarDebuggerModel' }

{ #category : '*Pulsar-Tool-LLM' }
PulsarDebuggerModel >> defineAgentActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: #stack with: [ :group |
			| agentModel agentActions |
			agentModel := self newAgentModel.
			agentActions := agentModel actions actionsFor: #toolbar.
			agentActions entries do: [ :each | each actionVisible: [ :aContext | aContext application settings isFeatureEnabled: #llm ] ].
			group
				priority: 200;
				addGroupWith: [ :agentGroup |
						agentGroup
							priority: 210;
							name: 'Agent';
							description: 'Agent actions on this stack';
							iconName: 'agent';
							beToolbarMenuButton;
							addAll: agentActions entries ] ]
]

{ #category : '*Pulsar-Tool-LLM' }
PulsarDebuggerModel >> newAgentModel [

	^ PulsarLLMDebugAgentModel on: self
]
