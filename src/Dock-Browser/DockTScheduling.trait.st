Trait {
	#name : 'DockTScheduling',
	#instVars : [
		'scheduler'
	],
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'private - scheduling' }
DockTScheduling >> newScheduler [

	^ DockWorker new 
		inTool: self class;
		start
]

{ #category : 'private - scheduling' }
DockTScheduling >> schedule: aBlock [

	^ self scheduler schedule: aBlock
]

{ #category : 'private - scheduling' }
DockTScheduling >> scheduler [

	^ scheduler ifNil: [ scheduler := self newScheduler ]
]
