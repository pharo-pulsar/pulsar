"
Add a task worker to be used in instances that require to queue tasks to be executed in FIFO order.
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
PulsarTTaskWorker >> queueTask: aBlock [
	"queue task works on a single working, ensure tasks are queued 
	 (they will happen in FIFO order)"

	^ self taskWorker schedule: aBlock
]

{ #category : 'private - scheduling' }
PulsarTTaskWorker >> schedule: aBlock [

	self 
		deprecated: 'This is confusing, use #queueTask:' 
		transformWith: 
			'`@receiver schedule: `@arg' -> 
			'`@receiver queueTask: `@arg'.

	^ self queueTask: aBlock
]

{ #category : 'private - scheduling' }
PulsarTTaskWorker >> scheduler [

	self 
		deprecated: 'Using the more clear taskWorker' 
		transformWith: '`@receiver scheduler' -> '`@receiver taskWorker'.

	^ self taskWorker
]

{ #category : 'private - scheduling' }
PulsarTTaskWorker >> stopScheduler [

	self 
		deprecated: 'Using the more clear taskWorker' 
		transformWith: '`@receiver stopScheduler' -> '`@receiver stopTaskWorker'.

	self stopTaskWorker
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
