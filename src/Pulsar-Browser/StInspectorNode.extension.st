Extension { #name : 'StInspectorNode' }

{ #category : '*Pulsar-Browser' }
StInspectorNode >> asPulsarInspectorModel [

	^ PulsarInspectorModel on: self rawValue
]
