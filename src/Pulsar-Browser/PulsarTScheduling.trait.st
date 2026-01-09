Trait {
	#name : 'PulsarTScheduling',
	#instVars : [
		'scheduler'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'private - scheduling' }
PulsarTScheduling >> newScheduler [

	^ PulsarWorker new 
		inTool: self class;
		start
]

{ #category : 'private - scheduling' }
PulsarTScheduling >> queueTask: aBlock [
	"queue task works on a single working, ensure tasks are queued 
	 (they will happen in FIFO order)"

	^ self scheduler schedule: aBlock
]

{ #category : 'private - scheduling' }
PulsarTScheduling >> schedule: aBlock [

	self 
		deprecated: 'This is confusing, use #queueTask:' 
		transformWith: 
			'`@receiver schedule: `@arg' -> 
			'`@receiver queueTask: `@arg'.

	^ self queueTask: aBlock
]

{ #category : 'private - scheduling' }
PulsarTScheduling >> scheduler [

	^ scheduler ifNil: [ scheduler := self newScheduler ]
]

{ #category : 'private - scheduling' }
PulsarTScheduling >> stopScheduler [

	scheduler ifNil: [ ^ self ].
	scheduler stop
]
