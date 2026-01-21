Class {
	#name : 'PulsarRepositoryCommitModel',
	#superclass : 'PulsarRepositoryBaseModel',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'private' }
PulsarRepositoryCommitModel >> authorInitialsOf: aString [
	| separated |

	separated := aString normalizeCamelCase substrings: ' .-'.
	separated size > 1 ifTrue: [ 
		^ (separated first: 2) collect: [ :each | each first asUppercase ] as: String ].
			
	(aString size > 1) ifTrue: [ ^ (aString first: 2) capitalized ].
	
	^ aString capitalized
]

{ #category : 'accessing' }
PulsarRepositoryCommitModel >> commit [

	^ self entity
]

{ #category : 'testing' }
PulsarRepositoryCommitModel >> isOutgoing [
	
	^ self repository isOutgoingCommit: self
]

{ #category : 'accessing' }
PulsarRepositoryCommitModel >> shortCommitAuthor [

	^ self authorInitialsOf: self commit author
]

{ #category : 'accessing' }
PulsarRepositoryCommitModel >> shortCommitId [

	^ self commit shortId
]

{ #category : 'accessing' }
PulsarRepositoryCommitModel >> shortCommitMessage [
	
	^ (self commit comment truncateWithElipsisTo: 180) withSeparatorsCompacted
]
