"
tags are not branches, clearly.
but they behave en many ways like one...
"
Class {
	#name : 'PulsarRepositoryTagBranchView',
	#superclass : 'PulsarRepositoryBaseBranchView',
	#category : 'Pulsar-Tool-Repositories-Branches',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Branches'
}

{ #category : 'private' }
PulsarRepositoryTagBranchView >> branches [

	^ self model tags
]

{ #category : 'accessing' }
PulsarRepositoryTagBranchView >> label [

	^ 'tags'
]
