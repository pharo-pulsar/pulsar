Class {
	#name : 'PulsarRepositoryLocateDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'panelPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View-Repositories',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Repositories'
}

{ #category : 'layout' }
PulsarRepositoryLocateDialog >> defaultLayout [

	^ SpBoxLayout newVertical
		add: panelPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryLocateDialog >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: 'Cancel' do: [ :aPresenter |
			aPresenter
				beCancel;
				close ];
		addDefaultButton: 'Locate' do: [ :aPresenter |
			panelPresenter validate.
			aPresenter
				beOk;
				close ]
]

{ #category : 'initialization' }
PulsarRepositoryLocateDialog >> initializePresenters [

	panelPresenter := self instantiate: IceTipLocalRepositoryPanel
]

{ #category : 'initialization' }
PulsarRepositoryLocateDialog >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Locate Repository';
		initialExtent: 600@220
]

{ #category : 'accessing' }
PulsarRepositoryLocateDialog >> location [

	^ panelPresenter location
]

{ #category : 'accessing' }
PulsarRepositoryLocateDialog >> location: aFileReference [

	panelPresenter location: aFileReference
]
