Extension { #name : 'SpAction' }

{ #category : '*Dock-Browser' }
SpAction >> asPvAction [
	self flag: #TOREMOVE.
	^ self
]

{ #category : '*Dock-Browser' }
SpAction >> asSpecWithContext: aContext [

	self context: aContext
]
