Class {
	#name : 'DockRepositoryPatchPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'headerPresenter',
		'patchPresenter'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'layout' }
DockRepositoryPatchPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		vAlignStart;
		add: headerPresenter;
		add: patchPresenter;
		yourself
]

{ #category : 'initialization' }
DockRepositoryPatchPresenter >> initializePresenters [

	self addStyle: 'dockRepositoryPatch'.

	headerPresenter := self instantiate: DockEditorToolbarPresenter.
	patchPresenter := self instantiate: SpPatchPresenter.
]

{ #category : 'initialization' }
DockRepositoryPatchPresenter >> updatePresenter [
				
	self model ifNil: [ ^ self ].	
				
	headerPresenter title: self model summary.
	patchPresenter patch: self model patch
]
