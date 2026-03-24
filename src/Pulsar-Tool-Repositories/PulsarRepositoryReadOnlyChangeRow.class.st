Class {
	#name : 'PulsarRepositoryReadOnlyChangeRow',
	#superclass : 'PulsarRepositoryChangeRow',
	#category : 'Pulsar-Tool-Repositories-View-Editor',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Editor'
}

{ #category : 'layout' }
PulsarRepositoryReadOnlyChangeRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: imagePresenter expand: false;
		add: labelPresenter;
		yourself
]
