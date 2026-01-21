Class {
	#name : 'PulsarDebuggerContextInspector',
	#superclass : 'PulsarDebuggerInspector',
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'defaults' }
PulsarDebuggerContextInspector class >> defaultPanelPosition [

	^ super defaultPanelPosition
		column: 2;
		yourself
]

{ #category : 'private' }
PulsarDebuggerContextInspector >> inspectorModelOf: aContextModel [

	^ aContextModel entity
]

{ #category : 'initialization' }
PulsarDebuggerContextInspector >> title [

	^ 'Context'
]
