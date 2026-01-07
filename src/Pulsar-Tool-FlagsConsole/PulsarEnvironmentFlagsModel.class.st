Class {
	#name : 'PulsarEnvironmentFlagsModel',
	#superclass : 'PulsarFlagsModel',
	#category : 'Pulsar-Tool-FlagsConsole',
	#package : 'Pulsar-Tool-FlagsConsole'
}

{ #category : 'private' }
PulsarEnvironmentFlagsModel >> calculateEnvironment [
	
	"itself"
	^ self environmentModel
]

{ #category : 'accessing' }
PulsarEnvironmentFlagsModel >> title [

	^ 'Flags on Environment'
]
