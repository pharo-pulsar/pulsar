Extension { #name : 'SpAction' }

{ #category : '*Dock-Browser' }
SpAction >> asPvAction [

	^ self
]

{ #category : '*Dock-Browser' }
SpAction >> asSpecWithContext: aContext [

	self context: aContext
]
