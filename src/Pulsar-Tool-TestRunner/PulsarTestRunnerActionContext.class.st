"
A context to perform test runner actions. Consolidates doRunSelected, doRunAll, and doRefresh so they can be invoked from both the browser and the tests view without code duplication.
"
Class {
	#name : 'PulsarTestRunnerActionContext',
	#superclass : 'PulsarActionContext',
	#instVars : [
		'model'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'actions' }
PulsarTestRunnerActionContext >> doDebugCase: aCase [

	self scheduleJob: [ :statusbar |
		| exec |
		exec := PulsarTestRunnerExecution on: self notificationCenter fromModel: self model.
		statusbar pushMessage: ('Debugging {1}>>{2}' format: {
			aCase testClass name.
			aCase testSelector }).
		self model
			debugCase: aCase 
			announcingTo: self notificationCenter ]
]

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
		| exec |
	
			exec := PulsarTestRunnerExecution on: self notificationCenter fromModel: self model.
			self notificationCenter announce: (PulsarTestRunStarted newValue: exec).
			statusbar pushMessage: ('Running {1}>>{2}' format: {
				aCase testClass name.
				aCase testSelector }).
			self model
				runCase: aCase 
				announcingTo: self notificationCenter ]
]

{ #category : 'actions' }
PulsarTestRunnerActionContext >> doRunSuite: aSuite [

	self scheduleJob: [ :statusbar |
		|  exec |
		exec := PulsarTestRunnerExecution on: self notificationCenter fromModel: self model.
		self notificationCenter announce: (PulsarTestRunStarted newValue: exec).
		statusbar pushMessage: ('Running {1}' format: { aSuite name }).
		self model 
			runSuite: aSuite 
			announcingTo: self notificationCenter ]
]

{ #category : 'accessing' }
PulsarTestRunnerActionContext >> model [

	^ model ifNil: [ self owner model ]
]

{ #category : 'accessing' }
PulsarTestRunnerActionContext >> model: anObject [

	model := anObject
]
