Extension { #name : 'IceLogVersion' }

{ #category : '*Pulsar-Tool-Repositories' }
IceLogVersion >> asRingDefinition [

	^ self definition copy 
		stamp: self timeStamp asString;
		author: self author;
		yourself
]
