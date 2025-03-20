Class {
	#name : 'DockTranscriptTest',
	#superclass : 'DockBaseViewTest',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'tests' }
DockTranscriptTest >> testTranscriptWorkerIsClosedWhenClosingBrowser [
	| processes1 processes2 |
	
	processes1 := (Processor allProcesses 
		select: [ :each | each name beginsWith: 'DockTranscript' ])
		reject: [ :each | each isTerminated ].

	self openBrowser.
	self waitForUI.
	browser close.
	self waitForUI.

	processes2 := (Processor allProcesses 
		select: [ :each | each name beginsWith: 'DockTranscript' ])
		reject: [ :each | each isTerminated ].
	
	self assertCollection: processes2 hasSameElements: processes1
]
