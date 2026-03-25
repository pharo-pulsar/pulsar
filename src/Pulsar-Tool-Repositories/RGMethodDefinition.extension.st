Extension { #name : 'RGMethodDefinition' }

{ #category : '*Pulsar-Tool-Repositories' }
RGMethodDefinition >> beFromRemote [

	^ self 
		annotationNamed: #fromRemote
		put: true
]

{ #category : '*Pulsar-Tool-Repositories' }
RGMethodDefinition >> isFromRemote [

	^ self 
		annotationNamed: #fromRemote
		ifAbsent: [ false ]
]
