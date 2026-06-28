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
	self notificationCenter announce: PulsarTestRunFinished new
]

{ #category : 'actions' }
PulsarTestRunnerActionContext >> doRunAllFor: aModel [

	self scheduleJob: [ :statusbar |
		statusbar pushMessage: 'Running all tests'.
		aModel runAllTests.
		self notificationCenter announce: (PulsarTestRunFinished newValue: aModel) ]
]

{ #category : 'actions' }
PulsarTestRunnerActionContext >> doRunSelectedFor: aModel [

	self scheduleJob: [ :statusbar |
		statusbar pushMessage: 'Running selected tests'.
		aModel runSelectedTests.
		self notificationCenter announce: (PulsarTestRunFinished newValue: aModel) ]
]
