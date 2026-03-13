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
		  addFlag: #logLevel 
				description: 'Enable trace log level (info, warn, debug, trace). Default = warn'
				positionalSpec: [ :positional | positional defaultValue: [ :arg :app | 'warn' ] ];
		  yourself
]

{ #category : 'execution' }
PulsarCLIApplication >> enableTrace: aLevel [
	| index |
	
	index := #('info' 'warn' 'debug' 'trace') 
		indexOf: aLevel 
		ifAbsent: [ 
			self error: 'Invalid parameter, it should be --logLevel=info|warn|debug|trace' ].
	
	logger enable 
		logLevel: index;
		sendToStdout	
]

{ #category : 'execution' }
PulsarCLIApplication >> execute [

	"reset cleans up but it does not stop the execution of the IDE" 
	(self hasFlag: #reset) ifTrue: [ self forceReset ].
	(self hasFlag: #logLevel) 
		ifTrue: [ self enableTrace: (self positional: #logLevel) ]
		ifFalse: [ logger disable ].
	
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
