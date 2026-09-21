Class {
	#name : 'PulsarRepositoryRiver',
	#superclass : 'PvBaseModel',
	#instVars : [
		'river'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarRepositoryRiver >> at: aNumber [

	^ PulsarRepositoryRiverCommit
		newEnvironment: self environmentModel
		parent: self
		entity: (self river at: aNumber)
]

{ #category : 'accessing' }
PulsarRepositoryRiver >> river [

	^ river ifNil: [ 
		river := GitRiver
    			historyListModelOn: self repositoryLocation fullName
    			includeAllReferences: true
    			pageSize: 10 ]
]
