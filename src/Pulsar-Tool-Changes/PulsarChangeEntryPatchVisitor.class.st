Class {
	#name : 'PulsarChangeEntryPatchVisitor',
	#superclass : 'EpEntryContentVisitor',
	#instVars : [
		'patchPresenter'
	],
	#category : 'Pulsar-Tool-Changes',
	#package : 'Pulsar-Tool-Changes'
}

{ #category : 'instance creation' }
PulsarChangeEntryPatchVisitor class >> on: aPatchPresenter [

	^ self new 
		patchPresenter: aPatchPresenter;
		yourself
]

{ #category : 'accessing' }
PulsarChangeEntryPatchVisitor >> patchPresenter: aPatchPresenter [

	patchPresenter := aPatchPresenter
]

{ #category : 'visitor' }
PulsarChangeEntryPatchVisitor >> visitBehaviorCommentChange: aChange [

	patchPresenter 
		patchFrom: aChange oldComment
		to: aChange newComment
]

{ #category : 'visitor' }
PulsarChangeEntryPatchVisitor >> visitEvent: aChange [

	patchPresenter patchFrom: '' to: ''
]

{ #category : 'visitor' }
PulsarChangeEntryPatchVisitor >> visitMethodAddition: aChange [

	patchPresenter 
		patchFrom: ''
		to: aChange sourceCode
]

{ #category : 'visitor' }
PulsarChangeEntryPatchVisitor >> visitMethodModification: aChange [

	patchPresenter 
		patchFrom: aChange oldSourceCode 
		to: aChange newSourceCode
]

{ #category : 'visitor' }
PulsarChangeEntryPatchVisitor >> visitMethodRemoval: aChange [

	patchPresenter 
		patchFrom: aChange sourceCode
		to: ''
]

{ #category : 'visitor' }
PulsarChangeEntryPatchVisitor >> visitProtocolAddition: aChange [

	self visitEvent: aChange
]
