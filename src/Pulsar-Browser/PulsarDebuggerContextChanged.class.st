Class {
	#name : 'PulsarDebuggerContextChanged',
	#superclass : 'PulsarAnnouncement',
	#instVars : [
		'updateTopContext'
	],
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'initialization' }
PulsarDebuggerContextChanged >> initialize [

	super initialize.
	updateTopContext := false
]

{ #category : 'testing' }
PulsarDebuggerContextChanged >> isUpdateTopContext [

	^ updateTopContext
]

{ #category : 'accessing' }
PulsarDebuggerContextChanged >> updateTopContext: aBoolean [

	updateTopContext := aBoolean
]
