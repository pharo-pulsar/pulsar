Extension { #name : 'PvMethodModel' }

{ #category : '*Pulsar-Tool-TestRunner' }
PvMethodModel >> defineTestRunnerDecorationActionsOn: aBuilder [
	"action decorations for this method. 
	 this group should define all actions the method model can execute *everywhere* it is 
	 found (editors, methods lists...)."
	<dockActions>
	
	self isTestMethod ifFalse: [ ^ self ].

	aBuilder addGroup: #decoration with: [ :group | group
		addActionWith: [ :action | action
			name: 'Run Test';
			description: 'Execute test of current method';
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
PvMethodModel >> prepareRunnerSelection: aRunnerModel [

	aRunnerModel selectCaseFromModel: self
]

{ #category : '*Pulsar-Tool-TestRunner' }
PvMethodModel >> runTestAnnouncingTo: anAnnouncer [
	| testSuite |
	
	testSuite := TestSuite new
		addTest: (self methodClass selector: self entity selector);
		yourself.

	NewTestRunner 
		executeSuite: testSuite 
		announcingTo: anAnnouncer 
		inMode: ExecutionMode debugMode
]
