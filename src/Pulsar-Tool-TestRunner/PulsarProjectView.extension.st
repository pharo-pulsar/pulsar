Extension { #name : 'PulsarProjectView' }

{ #category : '*Pulsar-Tool-TestRunner' }
PulsarProjectView >> defineTestRunnerActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #project with: [ :group | group 	
		addActionWith: [ :action | action 
			priority: 1000;
			name: 'Test Runner';
			description: 'Open a Test Runner on this Project';
			iconName: 'testRunner';
			actionEnabled: [ 
				self hasSelectedEntity 
					and: [ (self model findRootForEntity: self selectedEntity) isProject ] ];
			action: [ 
				self scheduleTask: [
					(PulsarTestRunnerBrowser
						newApplication: self application
						model: (PulsarTestRunnerModel 
							newEnvironment: self model environmentModel 
							entity: (self model findRootForEntity: self selectedEntity) )) 
						open ] ] ] ]
]
