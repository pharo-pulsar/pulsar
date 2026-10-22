"
I spawn and own a Unix subprocess with pipe-backed standard input, output, and error streams.

I am an internal helper for LLM APIs that need a long-lived bidirectional subprocess, such as the Claude Code CLI in stream-json mode. I wrap a GIOPipedProcess, which uses g_spawn_async_with_pipes to create the child and its three pipes. All direct GLib calls are executed through GRunLoop defer: so they run in the GTK run loop, while blocking line reads are delegated to GIOChannelReadLineListener and its TFWorker.

The caller writes UTF-8 lines to #writeLine: and reads lines through #startStdoutListener: and #startStderrListener:. I monitor the child with kill -0 and terminate it on #stop.
"
Class {
	#name : 'PulsarLLMUnixProcess',
	#superclass : 'Object',
	#instVars : [
		'process',
		'inChannel',
		'outChannel',
		'errChannel',
		'stdoutListener',
		'stderrListener',
		'monitorProcess',
		'running',
		'terminationBlock'
	],
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'run loop' }
PulsarLLMUnixProcess class >> defer: aBlock [
	"Run a GLib call in the GTK run loop. Fall back to the receiver when no loop is running."
	| runLoop |
	
	runLoop := GRunLoop current.
	^ runLoop 
		ifNotNil: [ runLoop defer: aBlock ]
		ifNil: [ aBlock value ]
]

{ #category : 'ffi' }
PulsarLLMUnixProcess class >> kill: aPid signal: aSignal [

	^ self ffiCall: #(int kill (int aPid, int aSignal)) module: LibC
]

{ #category : 'spawning' }
PulsarLLMUnixProcess class >> spawn: aCommand arguments: aCollection workingDirectory: aDirectory [
	"Spawn aCommand with pipes and answer the process wrapper."
	| process workingDirectory |
	
	workingDirectory := aDirectory 
		ifNotNil: [ aDirectory asFileReference ]
		ifNil: [ FileLocator imageDirectory ].
	
	process := self defer: [
		GIOPipedProcess
			spawn: aCommand
			arguments: aCollection
			workingDirectory: workingDirectory fullName
			flags: GSpawnFlags G_SPAWN_SEARCH_PATH ].
	
	^ self basicNew initializeProcess: process
]

{ #category : 'accessing' }
PulsarLLMUnixProcess >> errChannel [

	^ errChannel ifNil: [ errChannel := self class defer: [ process errChannel ] ]
]

{ #category : 'accessing' }
PulsarLLMUnixProcess >> inChannel [

	^ inChannel ifNil: [ inChannel := self class defer: [ process inChannel ] ]
]

{ #category : 'initialization' }
PulsarLLMUnixProcess >> initializeProcess: aProcess [

	self initialize.

	process := aProcess.
	running := true.
	self startMonitor
]

{ #category : 'accessing' }
PulsarLLMUnixProcess >> isRunning [

	^ running
]

{ #category : 'accessing' }
PulsarLLMUnixProcess >> onTerminate: aBlock [

	terminationBlock := aBlock
]

{ #category : 'accessing' }
PulsarLLMUnixProcess >> outChannel [

	^ outChannel ifNil: [ outChannel := self class defer: [ process outChannel ] ]
]

{ #category : 'accessing' }
PulsarLLMUnixProcess >> pid [

	^ process 
		ifNotNil: [ process pid ] 
		ifNil: [ nil ]
]

{ #category : 'accessing' }
PulsarLLMUnixProcess >> process [

	^ process
]

{ #category : 'monitoring' }
PulsarLLMUnixProcess >> processExists [

	process ifNil: [ ^ false ].
	^ (self class kill: process pid signal: 0) = 0
]

{ #category : 'monitoring' }
PulsarLLMUnixProcess >> startMonitor [

	monitorProcess := [
		[ self isRunning ] whileTrue: [
			250 milliSeconds wait.
			(self isRunning and: [ self processExists not ]) ifTrue: [
				running := false.
				terminationBlock ifNotNil: [ :block | block value ] ] ] 
	] 
	forkNamed: 'LLM process monitor'
]

{ #category : 'reading' }
PulsarLLMUnixProcess >> startStderrListener: aBlock [
	| channel listener |
	
	stderrListener ifNotNil: [ ^ self ].
	channel := self errChannel.
	listener := self class defer: [ 
		channel newReadLineListener: 'pulsar-llm-stderr' action: aBlock ].
	stderrListener := listener.
	listener start
]

{ #category : 'reading' }
PulsarLLMUnixProcess >> startStdoutListener: aBlock [
	| channel listener |
	
	stdoutListener ifNotNil: [ ^ self ].
	channel := self outChannel.
	listener := self class defer: [ 
		channel newReadLineListener: 'pulsar-llm-stdout' action: aBlock ].
	stdoutListener := listener.
	listener start
]

{ #category : 'lifecycle' }
PulsarLLMUnixProcess >> stop [
	"Close the streams, terminate the child if needed, and release the process."
	| wasRunning childPid |
	
	wasRunning := self isRunning.
	running := false.
	(monitorProcess isNotNil and: [ monitorProcess ~~ Processor activeProcess ])
		ifTrue: [ monitorProcess terminate ].
	self stopStdoutListener.
	self stopStderrListener.
	childPid := self pid.
	
	process ifNotNil: [
		[ self class defer: [ process close ] ]
		on: Error
		do: [ :e | 
			logger error: e.
			nil ] ].
	inChannel := outChannel := errChannel := nil.
	
	wasRunning ifTrue: [
		(childPid isNotNil and: [ (self class kill: childPid signal: 0) = 0 ]) 
			ifTrue: [ self class kill: childPid signal: 15 ].
		100 milliSeconds wait.
		(childPid isNotNil and: [ (self class kill: childPid signal: 0) = 0 ]) 
			ifTrue: [ self class kill: childPid signal: 9 ] ].
	
	process := nil.
	monitorProcess := nil
]

{ #category : 'reading' }
PulsarLLMUnixProcess >> stopStderrListener [

	stderrListener ifNotNil: [ :each | each stop ].
	stderrListener := nil
]

{ #category : 'reading' }
PulsarLLMUnixProcess >> stopStdoutListener [

	stdoutListener ifNotNil: [ :each | each stop ].
	stdoutListener := nil
]

{ #category : 'writing' }
PulsarLLMUnixProcess >> writeLine: aString [
	"Write aString as one UTF-8 line and flush it."
	| channel bytes offset written |
	
	channel := self inChannel.
	bytes := aString utf8Encoded, (String with: Character lf) utf8Encoded.
	offset := 1.
	[ offset <= bytes size ] whileTrue: [
		written := self class defer: [ 
			channel write: (bytes copyFrom: offset to: bytes size) ].
		(written isNil or: [ written <= 0 ]) ifTrue: [ 
			self error: 'Cannot write to LLM process' ].
		offset := offset + written ].
	self class defer: [ channel flush ]
]
