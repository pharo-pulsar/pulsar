Extension { #name : 'PulsarDebuggerModel' }

{ #category : '*Pulsar-Tool-LLM' }
PulsarDebuggerModel >> defineAgentActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: #stack with: [ :group |
			group
				priority: 200;
				addActionWith: [ :action |
						action
							priority: 210;
							name: 'Agent';
							description: 'Agent actions on this stack';
							iconName: 'agent';
							actionVisible: [ :aContext | aContext application settings isFeatureEnabled: #llm ];
							action: [ :aContext | (PulsarLLMAgent newModel: self callerAction: action callerPresenter: aContext) show ] ] ]
]

{ #category : '*Pulsar-Tool-LLM' }
PulsarDebuggerModel >> newAgentModel [

	^ PulsarLLMDebugAgentModel on: self
]
