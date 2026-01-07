Class {
	#name : 'PulsarRepositoriesSnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'initialization' }
PulsarRepositoriesSnapshot >> takeModelSnapshot: aPresenter [
	
	model := aPresenter model prepareForSnapshot
]
