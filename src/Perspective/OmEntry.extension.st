Extension { #name : 'OmEntry' }

{ #category : '*Perspective' }
OmEntry >> sourceCode [

	^ self content
]

{ #category : '*Perspective' }
OmEntry >> timeStamp [

	^ self tagAt: #timestamp
]
