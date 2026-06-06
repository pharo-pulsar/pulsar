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

{ #category : 'private - commandline' }
PulsarCLIApplication class >> addOpenFlagsTo: aSpec [

	aSpec
		addFlag: #reset description: 'Reset pulsar IDE (cleaning up snapshot and living processes)';
		addFlag: #logLevel
		description: 'Enable trace log level (info, warn, debug, trace). Default = warn'
		positionalSpec: [ :positional | positional defaultValue: [ :arg :app | 'warn' ] ]
]

{ #category : 'commandline' }
PulsarCLIApplication class >> commandSpecification [
	<commandline>
	| spec |
	
	spec := ClapCommandSpec id: #pulsar.
	spec
		aliases: #( 'openPulsar' ); "for backwards compatibility"
		description: 'Pulsar IDE command line interface';
		commandClass: self;
		addHelp.
	
	"as open is the default, add the flags for open too"
	self addOpenFlagsTo: spec.
	
	spec
		addSubcommand: self openSubcommandSpec;
		addSubcommand: self updateSubcommandSpec.
	
	^ spec
]

{ #category : 'private - commandline' }
PulsarCLIApplication class >> openSubcommandSpec [
	| spec |
	
	spec := ClapCommandSpec id: #open.
	spec
		description: 'Open Pulsar IDE';
		commandClass: self;
		addHelp.
		
	self addOpenFlagsTo: spec.
	
	^ spec
]

{ #category : 'private - commandline' }
PulsarCLIApplication class >> updateSubcommandSpec [

	^ (ClapCommandSpec id: #update)
		description: '(Try to) update Pulsar IDE';
		commandClass: self;
		addHelp;
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
	"always disable logger (in case I let one open)"

	logger disable.
	self executeSubcommand
]

{ #category : 'execution' }
PulsarCLIApplication >> executeOpen [
	"reset cleans up but it does not stop the execution of the IDE"

	(self hasFlag: #reset) ifTrue: [ self forceReset ].
	(self hasFlag: #logLevel) ifTrue: [ self enableTrace: (self positional: #logLevel) ].

	self runApplication
]

{ #category : 'execution' }
PulsarCLIApplication >> executeSubcommand [

	self isUpdateSubcommand ifTrue: [ ^ self executeUpdate ].
	self executeOpen
]

{ #category : 'execution' }
PulsarCLIApplication >> executeUpdate [

	PulsarUpdater update.
	self exitSuccess
]

{ #category : 'initialization' }
PulsarCLIApplication >> forceReset [
	"runs a reset of the application before restart."
	
	PulsarApplication resetLastSnapshot.
	PulsarApplication reset: true.
	Deprecation reset.
	
	"also clean processes that may have remained"
	(Processor allProcesses 
		select: [ :each | each name beginsWith: 'FFICallback' ])
		do: [ :each | each terminate ].	
	
	TKTWatchDog reset
]

{ #category : 'private - testing' }
PulsarCLIApplication >> isUpdateSubcommand [

	^ self context lastSubcommand specification identifier = #update
]

{ #category : 'execution' }
PulsarCLIApplication >> runApplication [
	
	self context doNotObeyExits.

	[ 
		PulsarApplication basicNew
			prepareAsStandaloneApplication;
			initialize;
			run ] 
	fork
]
