Extension { #name : 'Form' }

{ #category : '*Perspective' }
Form >> mergeBottomLeftWith: aForm [

	^ self 
		mergeWith: aForm 
		at: 0 @ (self extent y - aForm extent y)
]

{ #category : '*Perspective' }
Form >> mergeTopLeftWith: aForm [

	^ self 
		mergeWith: aForm 
		at: 0 @ 0
]

{ #category : '*Perspective' }
Form >> mergeTopRightWith: aForm [
	
	^ self 
		mergeWith: aForm 
		at: (aForm extent x @ 0)
]
