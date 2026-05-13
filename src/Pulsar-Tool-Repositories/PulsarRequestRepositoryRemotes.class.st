Class {
	#name : 'PulsarRequestRepositoryRemotes',
	#superclass : 'PulsarRequestToolAnnouncement',
	#category : 'Pulsar-Tool-Repositories-View-Remotes',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Remotes'
}

{ #category : 'testing' }
PulsarRequestRepositoryRemotes >> isUnique [

	^ true
]

{ #category : 'accessing' }
PulsarRequestRepositoryRemotes >> toolClass [

	^ PulsarRepositoryRemotesView
]
