Extension { #name : 'OmEntry' }

{ #category : '*Perspective' }
OmEntry >> isFromRemoteCommit [
	"this is all on a remote, technocally... but not a repository"

	^ false
]

{ #category : '*Perspective' }
OmEntry >> sourceCode [

	^ self content
]

{ #category : '*Perspective' }
OmEntry >> timeStamp [

	^ self tagAt: #timestamp
]
