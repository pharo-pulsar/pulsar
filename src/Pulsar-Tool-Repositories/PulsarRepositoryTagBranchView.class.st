"
tags are not branches, clearly.
but they behave en many ways like one...
"
Class {
	#name : 'PulsarRepositoryTagBranchView',
	#superclass : 'PulsarRepositoryBaseBranchView',
	#category : 'Pulsar-Tool-Repositories-View-Branches',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Branches'
}

{ #category : 'private' }
PulsarRepositoryTagBranchView >> branches [

	^ self model tags
]

{ #category : 'accessing' }
PulsarRepositoryTagBranchView >> label [

	^ 'tags'
]

{ #category : 'private' }
PulsarRepositoryTagBranchView >> maybeSort: aCollection [

	^ aCollection sort: #isHead descending,  #datetime descending
]
