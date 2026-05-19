Extension { #name : 'PulsarBrowser' }

{ #category : '*Pulsar-Tool-OpenCode' }
PulsarBrowser >> defineOpenCodeExtraActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #extra with: [ :group | group 
		addActionWith: [ :action | action 
			priority: 100;
			name: 'Open Code Console';
			description: 'Open an OpenCode console';
			action: [ self addUniquePresenterClass: PulsarOpenCodeConsole  ] 
		]
	]
]
