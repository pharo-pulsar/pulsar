Trait {
	#name : 'PulsarTJobHandler',
	#instVars : [
		'job'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'private' }
PulsarTJobHandler >> addStatusbarPresenter: aPresenter [
	"As the job will require to add a spinner, we need to implement this"

	self shouldBeImplemented
]

{ #category : 'accessing - jobs' }
PulsarTJobHandler >> jobEnd [

	job ifNil: [ ^ self ].
	job end
]

{ #category : 'accessing - jobs' }
PulsarTJobHandler >> jobStart [

	job ifNil: [ job := PulsarJobHandler on: self ].
	job start
]

{ #category : 'private' }
PulsarTJobHandler >> removeStatusbarPresenter: aPresenter [
	"As the job will require to add a spinner, we need to implement this"

	self shouldBeImplemented
]
