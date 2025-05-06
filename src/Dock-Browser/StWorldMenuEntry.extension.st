Extension { #name : 'StWorldMenuEntry' }

{ #category : '*Dock-Browser' }
StWorldMenuEntry >> accept: aSpotter [

	^ aSpotter visitMenuEntry: self
]
