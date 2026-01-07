Class {
	#name : 'PulsarTranscriptTest',
	#superclass : 'PulsarBaseViewTest',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'tests' }
PulsarTranscriptTest >> testTranscriptWorkerIsClosedWhenClosingBrowser [
	| processes1 processes2 |
	
	processes1 := (Processor allProcesses 
		select: [ :each | each name beginsWith: 'PulsarTranscript' ])
		reject: [ :each | each isTerminated ].

	self openBrowser.
	self waitForUI.
	browser close.
	self waitForUI.

	processes2 := (Processor allProcesses 
		select: [ :each | each name beginsWith: 'PulsarTranscript' ])
		reject: [ :each | each isTerminated ].
	
	self assertCollection: processes2 hasSameElements: processes1
]
