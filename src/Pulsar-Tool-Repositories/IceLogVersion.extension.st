Extension { #name : 'IceLogVersion' }

{ #category : '*Pulsar-Tool-Repositories' }
IceLogVersion >> asRingDefinition [

	^ self definition copy 
		timeStamp: self timeStamp;
		author: self author;
		beFromRemote;
		yourself
]
