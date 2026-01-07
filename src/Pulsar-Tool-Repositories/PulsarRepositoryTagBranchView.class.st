"
tags are not branches, clearly.
but they behave en many ways like one...
"
Class {
	#name : 'PulsarRepositoryTagBranchView',
	#superclass : 'PulsarRepositoryBaseBranchView',
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'private' }
PulsarRepositoryTagBranchView >> branches [

	^ self model tags
]
