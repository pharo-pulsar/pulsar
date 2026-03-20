Class {
	#name : 'PulsarRepositorySideBySidePresenter',
	#superclass : 'PulsarRepositoryPatchPresenter',
	#category : 'Pulsar-Tool-Repositories-View-Editor',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
PulsarRepositorySideBySidePresenter >> patchPresenterClass [

	^ SpPatchSideBySidePresenter
]
