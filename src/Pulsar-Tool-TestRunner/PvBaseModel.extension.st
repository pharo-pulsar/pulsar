Extension { #name : 'PvBaseModel' }

{ #category : '*Pulsar-Tool-TestRunner' }
PvBaseModel >> findTestRunnerProjectIn: aContext [
	"Find the PulsarBaseProjectModel containing self, checking the
	 context's own window first, then falling back to all application windows."
	| window |
	
	aContext isPresenter ifFalse: [ ^ nil ].
	
	window := aContext window.
	window isPulsarBrowser ifTrue: [
		| root |
		root := self findTestRunnerRootInWindow: window.
		root ifNotNil: [ ^ root ] ].

	aContext application windows 
		reject: [ :eachWindow | eachWindow = window ]
		thenDo: [ :eachWindow |
			eachWindow isPulsarBrowser ifTrue: [
				| root |
				root := self findTestRunnerRootInWindow: eachWindow.
				root ifNotNil: [ ^ root ] ] ].
	
	^ nil
]

{ #category : '*Pulsar-Tool-TestRunner' }
PvBaseModel >> findTestRunnerRootInWindow: aWindow [
	| projectView root |
	
	projectView := aWindow findPresenterClass: PulsarProjectView.
	projectView ifNil: [ ^ nil ].
	root := projectView model findRootForEntity: self.
	^ root isProject
		  ifTrue: [ root ]
		  ifFalse: [ nil ]
]

{ #category : '*Pulsar-Tool-TestRunner' }
PvBaseModel >> openTestRunnerInContext: aContext [
	| projectModel |
	
	projectModel := self findTestRunnerProjectIn: aContext.
	projectModel ifNil: [ ^ self ].
	
	aContext scheduleTask: [
		|  runnerModel |
		runnerModel := PulsarTestRunnerModel newEnvironment: self environmentModel entity: projectModel.
		self prepareRunnerSelection: runnerModel.
		(PulsarTestRunnerBrowser 
			newApplication: aContext application 
			model: runnerModel) 
			open ]
]

{ #category : '*Pulsar-Tool-TestRunner' }
PvBaseModel >> prepareRunnerSelection: aRunnerModel [

	"do nothing. Subclasses can define a selection"
]
