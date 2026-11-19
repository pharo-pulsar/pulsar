Extension { #name : 'MetacelloProjectSpec' }

{ #category : '*Pulsar-Browser' }
MetacelloProjectSpec >> projectName [

	^ self className allButFirst: 10 "'BaselineOf' size"
]
