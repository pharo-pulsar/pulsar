Extension { #name : 'StClassEntry' }

{ #category : '*Dock-Browser' }
StClassEntry >> accept: aSpotter [

	aSpotter visitClassEntry: self
]

{ #category : '*Dock-Browser' }
StClassEntry >> categoryLabel [

	^ 'class'
]
