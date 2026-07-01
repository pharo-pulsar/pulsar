"
A context to perform test runner actions. Consolidates doRunSelected, doRunAll, and doRefresh so they can be invoked from both the browser and the tests view without code duplication.
"
Class {
	#name : 'PulsarTestRunnerActionContext',
	#superclass : 'PulsarActionContext',
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'actions' }
PulsarTestRunnerActionContext >> doRefreshFor: aModel [

	aModel refresh.
	self notificationCenter announce: PulsarTestRunStarted new
]

{ #category : 'actions' }
PulsarTestRunnerActionContext >> doRunAllFor: aModel [

	self scheduleJob: [ :statusbar |
			| exec |
			exec := PulsarTestRunnerExecution on: self notificationCenter fromModel: aModel.
			self notificationCenter announce: (PulsarTestRunStarted newValue: exec).
			statusbar pushMessage: 'Running all tests'.
			aModel runAllTestsAnnouncingTo: self notificationCenter ]
]

{ #category : 'actions' }
PulsarTestRunnerActionContext >> doRunCase: aCase [

	self scheduleJob: [ :statusbar |
			| model exec |
			model := self owner model.
			exec := PulsarTestRunnerExecution on: self notificationCenter fromModel: model.
			self notificationCenter announce: (PulsarTestRunStarted newValue: exec).
			statusbar pushMessage: ('Running {1}>>{2}' format: {
						 aCase testClass name.
						 aCase testSelector }).
			model runCase: aCase announcingTo: self notificationCenter ]
]

{ #category : 'actions' }
PulsarTestRunnerActionContext >> doRunSuite: aSuite [

	self scheduleJob: [ :statusbar |
			| model exec |
			model := self owner model.
			exec := PulsarTestRunnerExecution on: self notificationCenter fromModel: model.
			self notificationCenter announce: (PulsarTestRunStarted newValue: exec).
			statusbar pushMessage: ('Running {1}' format: { aSuite name }).
			model runSuite: aSuite announcingTo: self notificationCenter ]
]
