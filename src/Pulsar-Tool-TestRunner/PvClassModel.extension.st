Extension { #name : 'PvClassModel' }

{ #category : '*Pulsar-Tool-TestRunner' }
PvClassModel >> defineTestRunnerDecorationActionsOn: aBuilder [
	"action decorations for this class. 
	 this group should define all actions the method class can execute *everywhere* it is 
	 found (editors, class lists...)."
	<dockActions>
	
	self isTestCase ifFalse: [ ^ self ].

	aBuilder addGroup: #decoration with: [ :group | group
		addActionWith: [ :action | action
			name: 'Run Test';
			description: ('Execute test of {1} class' format: { self name });
			iconName: 'play';
			presenterClass: PulsarMethodActionRunTestPresenter;
			action: [ :aContext | self runTestAnnouncingTo: aContext notificationCenter ] ];
		addActionWith: [ :action | action
			name: 'Open Test Runner';
			description: ('Open Test Runner for project containing {1}' format: { self name });
			iconName: 'testRunner';
			actionEnabled: [ :aContext | (self findTestRunnerProjectIn: aContext) isNotNil ];
			action: [ :aContext | self openTestRunnerInContext: aContext ] ] ]
]

{ #category : '*Pulsar-Tool-TestRunner' }
PvClassModel >> prepareRunnerSelection: aRunnerModel [

	aRunnerModel selectSuiteFromModel: self
]

{ #category : '*Pulsar-Tool-TestRunner' }
PvClassModel >> runTestAnnouncingTo: anAnnouncer [

	NewTestRunner 
		executeSuite: self entity suite 
		announcingTo: anAnnouncer 
		inMode: ExecutionMode runTestsMode
]
