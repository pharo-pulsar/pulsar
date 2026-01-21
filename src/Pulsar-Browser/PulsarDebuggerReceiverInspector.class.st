Class {
	#name : 'PulsarDebuggerReceiverInspector',
	#superclass : 'PulsarDebuggerInspector',
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'private' }
PulsarDebuggerReceiverInspector >> inspectorModelOf: aContextModel [ 

	^ aContextModel entity receiver
]

{ #category : 'initialization' }
PulsarDebuggerReceiverInspector >> title [

	^ 'Receiver'
]
