"
Add a task scheduler to be used in instances that require to schedule tasks to be executed in non-FIFO order.

Presenters using this trait need to purge tasks when close (sending `purgeTaskScheduler`).
"
Trait {
	#name : 'PulsarTTaskScheduler',
	#instVars : [
		'taskScheduler'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'private - scheduling' }
PulsarTTaskScheduler >> newTaskScheduler [

	^ TKTWorkerPool new
		name: self className;
		poolMaxSize: self taskSchedulerPoolSize;
		start
]

{ #category : 'private - scheduling' }
PulsarTTaskScheduler >> purgeTaskScheduler [

	taskScheduler ifNil: [ ^ self ].
	
	taskScheduler purge.
	taskScheduler stop.
	taskScheduler := nil
]

{ #category : 'private - scheduling' }
PulsarTTaskScheduler >> scheduleTask: aBlock [
	
	^ self taskScheduler schedule: aBlock 
]

{ #category : 'private - scheduling' }
PulsarTTaskScheduler >> taskScheduler [

	^ taskScheduler ifNil: [ taskScheduler := self newTaskScheduler ]
]

{ #category : 'private - scheduling' }
PulsarTTaskScheduler >> taskSchedulerPoolSize [

	^ 5
]
