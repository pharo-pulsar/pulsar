Class {
	#name : 'PulsarRepositoryCommitModel',
	#superclass : 'PulsarRepositoryBaseModel',
	#instVars : [
		'diffNode'
	],
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

{ #category : 'accessing' }
PulsarRepositoryCommitModel >> diffNode [

	^ diffNode ifNil: [ 
		diffNode := PulsarDiffNode 
			newRepository: self repository
			entity: self entity diffToParent tree ]
]

{ #category : 'testing' }
PulsarRepositoryCommitModel >> isBigChange [

	^ false
]

{ #category : 'testing' }
PulsarRepositoryCommitModel >> isOutgoing [
	
	^ self repository isOutgoingCommit: self
]

{ #category : 'testing' }
PulsarRepositoryCommitModel >> isRoot [

	^ true
]

{ #category : 'accessing' }
PulsarRepositoryCommitModel >> selectionAnnouncementClass [

	^ PulsarRepositoryCommitModelSelected
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
