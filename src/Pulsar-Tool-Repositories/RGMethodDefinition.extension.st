Extension { #name : 'RGMethodDefinition' }

{ #category : '*Pulsar-Tool-Repositories' }
RGMethodDefinition >> beFromRemote [

	^ self 
		annotationNamed: #fromRemote
		put: true
]

{ #category : '*Pulsar-Tool-Repositories' }
RGMethodDefinition >> beFromRemoteCommit: aCommit [

	self beFromRemote.
	self annotationNamed: #commit put: aCommit
]

{ #category : '*Pulsar-Tool-Repositories' }
RGMethodDefinition >> isFromRemoteCommit [

	^ self 
		annotationNamed: #fromRemote
		ifAbsent: [ false ]
]

{ #category : '*Pulsar-Tool-Repositories' }
RGMethodDefinition >> remoteCommit [

	^ self annotationNamed: #commit ifAbsent: [ nil ]
]
