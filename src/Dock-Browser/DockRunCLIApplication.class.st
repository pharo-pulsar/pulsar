Class {
	#name : 'DockRunCLIApplication',
	#superclass : 'ClapApplication',
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'command line' }
DockRunCLIApplication class >> commandSpecification [

	<commandline>
	
	^ (ClapCommandSpec id: #pulsar)
		  description: 'Run Pulsar IDE';
		  commandClass: self;
		  addHelp;
		  addFlag: #reset description: 'Reset pulsar IDE (cleaning up snapshot and living processes)';
		  "addPositional: #applicationName description: 'the name of the application to run';"
		  yourself
]

{ #category : 'execution' }
DockRunCLIApplication >> execute [

	"reset cleans up but it does not stop the execution of the IDE" 
	(self hasFlag: #reset) ifTrue: [ self forceReset ].
	
	self runApplication
]

{ #category : 'initialization' }
DockRunCLIApplication >> forceReset [
	"runs a reset of the application before restart."
	
	DockApplication resetLastSnapshot.
	DockApplication reset.
	Deprecation reset.
	
	TKTWatchDog reset
]

{ #category : 'executing' }
DockRunCLIApplication >> runApplication [
	self doNotQuitImage.

	[ 
		DockApplication basicNew
			prepareAsStandaloneApplication;
			initialize;
			run ] 
	fork
]
