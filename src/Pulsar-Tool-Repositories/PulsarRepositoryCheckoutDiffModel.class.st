"
A thin wrapper around a PulsarRepositoryModel that provides a checkout-specific diff.

It delegates everything to the underlying repositoryModel except diffNode,
which returns the diff between HEAD and the working copy (instead of the
default diffToReferenceCommit). Used by PulsarRepositoryCheckoutWindow to
show the incoming changes of a checkout/repair operation.
"
Class {
	#name : 'PulsarRepositoryCheckoutDiffModel',
	#superclass : 'Object',
	#instVars : [
		'repositoryModel'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarRepositoryCheckoutDiffModel class >> on: aRepositoryModel [

	^ self new
		  repositoryModel: aRepositoryModel;
		  yourself
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutDiffModel >> diffNode [

	^ repositoryModel checkoutDiffNode
]

{ #category : 'reflective operations' }
PulsarRepositoryCheckoutDiffModel >> doesNotUnderstand: aMessage [

	^ aMessage sendTo: repositoryModel
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutDiffModel >> repositoryModel [

	^ repositoryModel
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutDiffModel >> repositoryModel: aRepositoryModel [

	repositoryModel := aRepositoryModel
]
