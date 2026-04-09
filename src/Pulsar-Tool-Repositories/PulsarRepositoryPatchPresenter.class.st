Class {
	#name : 'PulsarRepositoryPatchPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'headerPresenter',
		'patchPresenter',
		'summaryPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View-Editor',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Editor'
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
	summaryPresenter := self newLabel 
		addStyle: 'summary';
		useMarkup.
	headerPresenter addPresenter: summaryPresenter.
	
	patchPresenter := (self instantiate: self patchPresenterClass)
		styleScheme: self application styleScheme;
		syntaxHighlightTheme: self application syntaxHighlightTheme;
		yourself	
]

{ #category : 'initialization' }
PulsarRepositoryPatchPresenter >> patchPresenterClass [

	^ SpPatchPresenter
]

{ #category : 'initialization' }
PulsarRepositoryPatchPresenter >> updatePresenter [
				
	self model ifNil: [ ^ self ].	
				
	headerPresenter title: self model description.
	summaryPresenter label: self model summary.
	
	patchPresenter patch: self model patch
]
