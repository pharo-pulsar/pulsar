Class {
	#name : 'PulsarRepositoryPatchPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'headerPresenter',
		'patchPresenter'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'layout' }
PulsarRepositoryPatchPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		vAlignStart;
		add: headerPresenter;
		add: patchPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryPatchPresenter >> initializePresenters [

	self addStyle: 'pulsarRepositoryPatch'.

	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	patchPresenter := self instantiate: SpPatchPresenter.
]

{ #category : 'initialization' }
PulsarRepositoryPatchPresenter >> updatePresenter [
				
	self model ifNil: [ ^ self ].	
				
	headerPresenter title: self model summary.
	patchPresenter patch: self model patch
]
