Extension { #name : 'PulsarBaseProjectModel' }

{ #category : '*Pulsar-Tool-TestRunner' }
PulsarBaseProjectModel >> defineTestRunnerActionOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #tools with: [ :group | group
		name: 'Tools';
		beDisplayedAsGroup;
		priority: 900;
		addActionWith: [ :action |action
			name: 'Test Runner';
			iconName: 'testNotRun';
			description: 'Open test runner for this project';
			shortcutKey: $t shift actionModifier;
			action: [ :aContext |
				aContext scheduleTask: [
					self halt.
					(PulsarTestRunnerBrowser
						newApplication: aContext application
						model: (PulsarTestRunnerModel 
							newEnvironment: self environmentModel 
							entity: self)) 
						open ] ] ] ]
]
