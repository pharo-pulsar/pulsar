Class {
	#name : 'PulsarRepositoryTagModel',
	#superclass : 'PulsarRepositoryBranchModel',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarRepositoryTagModel >> datetime [

	^ self entity commit datetime
]

{ #category : 'testing' }
PulsarRepositoryTagModel >> isHead [
	"tags are not head, but they may be placed on head"
	
	^ self entity repository headCommit = self entity commit
]
