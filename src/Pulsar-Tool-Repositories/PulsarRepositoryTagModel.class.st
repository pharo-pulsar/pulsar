Class {
	#name : 'PulsarRepositoryTagModel',
	#superclass : 'PulsarRepositoryBranchModel',
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'testing' }
PulsarRepositoryTagModel >> isHead [
	"tags are not head"
	
	^ false
]
