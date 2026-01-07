"
This is the command line launcher for Pulsar IDE.

"
Class {
	#name : 'PulsarCLIApplication',
	#superclass : 'ClapApplication',
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'command line' }
PulsarCLIApplication class >> commandSpecification [
	<commandline>
	
	^ (ClapCommandSpec id: #openPulsar)
		  description: 'Open Pulsar IDE';
		  commandClass: self;
		  addHelp;
		  addFlag: #reset description: 'Reset pulsar IDE (cleaning up snapshot and living processes)';
		  "addPositional: #applicationName description: 'the name of the application to run';"
		  yourself
]

{ #category : 'execution' }
PulsarCLIApplication >> execute [

	"reset cleans up but it does not stop the execution of the IDE" 
	(self hasFlag: #reset) ifTrue: [ self forceReset ].
	
	self runApplication
]

{ #category : 'initialization' }
PulsarCLIApplication >> forceReset [
	"runs a reset of the application before restart."
	
	PulsarApplication resetLastSnapshot.
	PulsarApplication reset.
	Deprecation reset.
	
	"also clean processes that may have remained"
	(Processor allProcesses 
		select: [ :each | each name beginsWith: 'FFICallback' ])
		do: [ :each | each terminate ].	
	
	TKTWatchDog reset
]

{ #category : 'executing' }
PulsarCLIApplication >> runApplication [
	
	self context doNotObeyExits.

	[ 
		PulsarApplication basicNew
			prepareAsStandaloneApplication;
			initialize;
			run ] 
	fork
]
