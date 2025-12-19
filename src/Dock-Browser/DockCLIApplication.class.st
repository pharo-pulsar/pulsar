"
This is the command line launcher for Pulsar IDE.

"
Class {
	#name : 'DockCLIApplication',
	#superclass : 'ClapApplication',
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'command line' }
DockCLIApplication class >> commandSpecification [
	<commandline>
	
	^ (ClapCommandSpec id: #dock)
		  description: 'Run Dock IDE';
		  commandClass: self;
		  addHelp;
		  addFlag: #reset description: 'Reset dock IDE (cleaning up snapshot and living processes)';
		  "addPositional: #applicationName description: 'the name of the application to run';"
		  yourself
]

{ #category : 'execution' }
DockCLIApplication >> execute [

	"reset cleans up but it does not stop the execution of the IDE" 
	(self hasFlag: #reset) ifTrue: [ self forceReset ].
	
	self runApplication
]

{ #category : 'initialization' }
DockCLIApplication >> forceReset [
	"runs a reset of the application before restart."
	
	DockApplication resetLastSnapshot.
	DockApplication reset.
	Deprecation reset.
	
	"also clean processes that may have remained"
	(Processor allProcesses 
		select: [ :each | each name beginsWith: 'FFICallback' ])
		do: [ :each | each terminate ].	
	
	TKTWatchDog reset
]

{ #category : 'executing' }
DockCLIApplication >> runApplication [
	
	self context doNotObeyExits.

	[ 
		DockApplication basicNew
			prepareAsStandaloneApplication;
			initialize;
			run ] 
	fork
]
