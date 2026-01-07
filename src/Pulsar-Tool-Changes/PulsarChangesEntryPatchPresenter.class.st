Class {
	#name : 'PulsarChangesEntryPatchPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'headerPresenter',
		'patchPresenter'
	],
	#category : 'Pulsar-Tool-Changes',
	#package : 'Pulsar-Tool-Changes'
}

{ #category : 'accessing' }
PulsarChangesEntryPatchPresenter >> beEmpty [

	self model: nil
]

{ #category : 'layout' }
PulsarChangesEntryPatchPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: patchPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarChangesEntryPatchPresenter >> initializePresenters [

	headerPresenter := self newLabel useMarkup.
	patchPresenter := self instantiate: SpPatchPresenter
]

{ #category : 'initialization' }
PulsarChangesEntryPatchPresenter >> updatePresenter [
	| content |

	self model ifNil: [
		headerPresenter label: 'No changes to show'.
		patchPresenter patchFrom: '' to: ''.
		^ self ].
		
	content := self model content.
	headerPresenter label: ((content accept: PulsarChangeEntryNameVisitor new)
		ifNil: [ 'Unknown' ]).
	content accept: (PulsarChangeEntryPatchVisitor on: patchPresenter)
]
