Class {
	#name : 'PulsarDiffRoot',
	#superclass : 'PulsarDiffNode',
	#instVars : [
		'fromCommit',
		'toCommit'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarDiffRoot class >> newRepository: aRepositoryModel 
	from: fromCommit
	to: toCommit
	tree: aTree [

	^ (self newRepository: aRepositoryModel entity: aTree)
		from: fromCommit to: toCommit;
		yourself
]

{ #category : 'accessing' }
PulsarDiffRoot >> from: aFromCommit to: aToCommit [

	fromCommit := aFromCommit.
	toCommit := aToCommit
]

{ #category : 'accessing' }
PulsarDiffRoot >> fromCommit [
	"this element has sense just in the root element. otherwise is nil"

	^ fromCommit
]

{ #category : 'accessing' }
PulsarDiffRoot >> toCommit [
	"this element has sense just in the root element. otherwise is nil"

	^ toCommit
]
