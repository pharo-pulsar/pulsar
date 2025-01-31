Extension { #name : 'StWorldMenuEntry' }

{ #category : '*Dock-Browser' }
StWorldMenuEntry >> accept: aSpotter [

	^ aSpotter visitMenuEntry: self
]

{ #category : '*Dock-Browser' }
StWorldMenuEntry >> categoryLabel [

	^ 'menu'
]
