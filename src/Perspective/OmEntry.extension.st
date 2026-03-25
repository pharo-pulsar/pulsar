Extension { #name : 'OmEntry' }

{ #category : '*Perspective' }
OmEntry >> isFromRemote [
	"this is all on a remote, so yes"

	^ true
]

{ #category : '*Perspective' }
OmEntry >> sourceCode [

	^ self content
]

{ #category : '*Perspective' }
OmEntry >> timeStamp [

	^ self tagAt: #timestamp
]
