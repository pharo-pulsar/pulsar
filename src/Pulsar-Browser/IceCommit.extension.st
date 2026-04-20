Extension { #name : 'IceCommit' }

{ #category : '*Pulsar-Browser' }
IceCommit >> normalizedAuthor [
	| substrings |

	substrings := self author substrings: ' -_'.
	substrings size = 1 ifTrue: [ 
		substrings := substrings anyOne splitCamelCase ].
		
	^ ' ' join: (substrings collect: [ :each | each capitalized ])
]
