"
Add a task worker to be used in instances that require to queue tasks to be executed in FIFO order.

Presenters using this trait need to purge tasks when close (sending `purgeTaskWorker`).
"
Trait {
	#name : 'PulsarTTaskWorker',
	#instVars : [
		'taskWorker'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'private - scheduling' }
PulsarTTaskWorker >> newTaskWorker [

	^ PulsarWorker new 
		inTool: self class;
		start
]

{ #category : 'private - scheduling' }
PulsarTTaskWorker >> purgeTaskWorker [

	taskWorker ifNil: [ ^ self ].
	
	taskWorker purge.
	[ taskWorker currentTaskExecution ifNotNil: #cancel ]
		on: Error
		do: [ :e | logger info: 'Task was already cancelled but we do not care.' ].
	taskWorker stop.
	taskWorker := nil
]

{ #category : 'private - scheduling' }
PulsarTTaskWorker >> queueTask: aBlock [
	"queue task works on a single working, ensure tasks are queued 
	 (they will happen in FIFO order)"

	^ self taskWorker schedule: aBlock
]

{ #category : 'private - scheduling' }
PulsarTTaskWorker >> stopTaskWorker [

	taskWorker ifNil: [ ^ self ].
	taskWorker stop
]

{ #category : 'private - scheduling' }
PulsarTTaskWorker >> taskWorker [

	^ taskWorker ifNil: [ taskWorker := self newTaskWorker ]
]
