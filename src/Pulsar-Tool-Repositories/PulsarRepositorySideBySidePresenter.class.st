Class {
	#name : 'PulsarRepositorySideBySidePresenter',
	#superclass : 'PulsarRepositoryPatchPresenter',
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'initialization' }
PulsarRepositorySideBySidePresenter >> patchPresenterClass [

	^ SpPatchSideBySidePresenter
]
