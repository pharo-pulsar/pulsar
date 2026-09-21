Extension { #name : 'GitRiverLayoutRow' }

{ #category : '*Pulsar-Tool-Repositories' }
GitRiverLayoutRow >> authorInitialsOf: aString [
	| separated |

	separated := aString normalizeCamelCase substrings: ' .-'.
	separated size > 1 ifTrue: [ 
		^ (separated first: 2) collect: [ :each | each first asUppercase ] as: String ].
			
	(aString size > 1) ifTrue: [ ^ (aString first: 2) capitalized ].
	
	^ aString capitalized
]

{ #category : '*Pulsar-Tool-Repositories' }
GitRiverLayoutRow >> commitAuthor [

	^ self commit author
]

{ #category : '*Pulsar-Tool-Repositories' }
GitRiverLayoutRow >> id [

	^ self commit id
]

{ #category : '*Pulsar-Tool-Repositories' }
GitRiverLayoutRow >> normalizedCommitAuthor [
	| substrings |

	substrings := self commitAuthor substrings: ' -_'.
	substrings size = 1 ifTrue: [ 
		substrings := substrings anyOne splitCamelCase ].
		
	^ ' ' join: (substrings collect: [ :each | each capitalized ])
]

{ #category : '*Pulsar-Tool-Repositories' }
GitRiverLayoutRow >> shortCommitAuthor [

	^ self authorInitialsOf: self commitAuthor
]

{ #category : '*Pulsar-Tool-Repositories' }
GitRiverLayoutRow >> shortCommitMessage [

	^ self commit messageSummary
]

{ #category : '*Pulsar-Tool-Repositories' }
GitRiverLayoutRow >> shortId [

	^ self commit shortId: 7
]
