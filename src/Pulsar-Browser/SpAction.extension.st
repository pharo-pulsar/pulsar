Extension { #name : 'SpAction' }

{ #category : '*Pulsar-Browser' }
SpAction >> asPvAction [
	self flag: #TOREMOVE.
	^ self
]

{ #category : '*Pulsar-Browser' }
SpAction >> asSpecWithContext: aContext [

	self context: aContext
]
