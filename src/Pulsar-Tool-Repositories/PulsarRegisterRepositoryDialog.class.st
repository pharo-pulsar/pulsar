"
A dialog to obtain a registering repository model (that can later be executed)
"
Class {
	#name : 'PulsarRegisterRepositoryDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'newRepositoryPresenter',
		'locateRepositoryPresenter',
		'cloneRepositoryPresenter',
		'lastSelectedPresenter',
		'repositoryCreator'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'layout' }
PulsarRegisterRepositoryDialog >> defaultLayout [

	^ SpTabLayout new 
		add: cloneRepositoryPresenter 	label: 'Clone';
		add: locateRepositoryPresenter 	label: 'Locate';
		add: newRepositoryPresenter		label: 'Create';
		whenTabSelectedDo: [ :ann |
			lastSelectedPresenter := ann presenter ];
		yourself
]

{ #category : 'initialization' }
PulsarRegisterRepositoryDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: 'Cancel' do: [ :aPresenter | 
			aPresenter 
				beCancel; 
				close ];
		addDefaultButton: 'Register' do: [ :aPresenter |
		 	"I need to take the real value before closing (which will reset the tab, as 
		 	 it will call tab selected when removing)"
			repositoryCreator := lastSelectedPresenter repositoryCreator.
			aPresenter
				beOk; 
				close ]
]

{ #category : 'initialization' }
PulsarRegisterRepositoryDialog >> initializePresenters [

	newRepositoryPresenter := self instantiate: IceTipNewRepositoryPanel.
	locateRepositoryPresenter := self instantiate: IceTipLocalRepositoryPanel.
	cloneRepositoryPresenter := self instantiate: IceTipGitRepositoryPanel
]

{ #category : 'initialization' }
PulsarRegisterRepositoryDialog >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Register Repository';
		initialExtent: 600@330
]

{ #category : 'accessing' }
PulsarRegisterRepositoryDialog >> repositoryCreator [

	^ repositoryCreator
]

{ #category : 'initialization' }
PulsarRegisterRepositoryDialog >> updatePresenter [

	self layout selectIndex: 1
]
