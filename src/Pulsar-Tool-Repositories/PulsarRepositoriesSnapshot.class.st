Class {
	#name : 'PulsarRepositoriesSnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#instVars : [
		'hideSystemProjects'
	],
	#category : 'Pulsar-Tool-Repositories-View-Repositories',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Repositories'
}

{ #category : 'restoring' }
PulsarRepositoriesSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter hideSystemProjects: hideSystemProjects
]

{ #category : 'initialization' }
PulsarRepositoriesSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	hideSystemProjects := aPresenter isHideSystemProjects
]
