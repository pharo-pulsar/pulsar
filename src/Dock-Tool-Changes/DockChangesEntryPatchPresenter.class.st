Class {
	#name : 'DockChangesEntryPatchPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'headerPresenter',
		'patchPresenter'
	],
	#category : 'Dock-Tool-Changes',
	#package : 'Dock-Tool-Changes'
}

{ #category : 'accessing' }
DockChangesEntryPatchPresenter >> beEmpty [

	self model: nil
]

{ #category : 'layout' }
DockChangesEntryPatchPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: patchPresenter;
		yourself
]

{ #category : 'initialization' }
DockChangesEntryPatchPresenter >> initializePresenters [

	headerPresenter := self newLabel useMarkup.
	patchPresenter := self instantiate: SpPatchPresenter
]

{ #category : 'initialization' }
DockChangesEntryPatchPresenter >> updatePresenter [
	| content |

	self model ifNil: [
		headerPresenter label: 'No changes to show'.
		patchPresenter patchFrom: '' to: ''.
		^ self ].
		
	content := self model content.
	headerPresenter label: ((content accept: DockChangeEntryNameVisitor new)
		ifNil: [ 'Unknown' ]).
	content accept: (DockChangeEntryPatchVisitor on: patchPresenter)
]
