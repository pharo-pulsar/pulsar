Extension { #name : 'StMethodEntry' }

{ #category : '*Dock-Browser' }
StMethodEntry >> accept: aSpotter [

	aSpotter visitMethodEntry: self
]

{ #category : '*Dock-Browser' }
StMethodEntry >> categoryLabel [

	^ 'method'
]
