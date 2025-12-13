Class {
	#name : 'DockRepositoryCommitModel',
	#superclass : 'DockRepositoryBaseModel',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'private' }
DockRepositoryCommitModel >> authorInitialsOf: aString [
	| separated |

	separated := aString normalizeCamelCase substrings: ' .-'.
	separated size > 1 ifTrue: [ 
		^ (separated first: 2) collect: [ :each | each first asUppercase ] as: String ].
			
	(aString size > 1) ifTrue: [ ^ (aString first: 2) capitalized ].
	
	^ aString capitalized
]

{ #category : 'accessing' }
DockRepositoryCommitModel >> commit [

	^ self entity
]

{ #category : 'testing' }
DockRepositoryCommitModel >> isOutgoing [
	
	^ self repository isOutgoingCommit: self
]

{ #category : 'accessing' }
DockRepositoryCommitModel >> shortCommitAuthor [

	^ self authorInitialsOf: self commit author
]

{ #category : 'accessing' }
DockRepositoryCommitModel >> shortCommitId [

	^ self commit shortId
]

{ #category : 'accessing' }
DockRepositoryCommitModel >> shortCommitMessage [
	
	^ (self commit comment truncateWithElipsisTo: 180) withSeparatorsCompacted
]
