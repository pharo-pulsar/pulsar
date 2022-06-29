Extension { #name : #Form }

{ #category : #'*NewTools-PerspectiveBrowser' }
Form >> mergeBottomLeftWith: aForm [

	^ self 
		mergeWith: aForm 
		at: 0 @ (self extent y - aForm extent y)
]

{ #category : #'*NewTools-PerspectiveBrowser' }
Form >> mergeTopLeftWith: aForm [

	^ self 
		mergeWith: aForm 
		at: 0 @ 0
]

{ #category : #'*NewTools-PerspectiveBrowser' }
Form >> mergeTopRightWith: aForm [
	
	^ self 
		mergeWith: aForm 
		at: (aForm extent x @ 0)
]
