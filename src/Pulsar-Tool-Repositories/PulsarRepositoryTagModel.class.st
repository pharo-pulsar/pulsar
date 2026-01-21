Class {
	#name : 'PulsarRepositoryTagModel',
	#superclass : 'PulsarRepositoryBranchModel',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'testing' }
PulsarRepositoryTagModel >> isHead [
	"tags are not head"
	
	^ false
]
