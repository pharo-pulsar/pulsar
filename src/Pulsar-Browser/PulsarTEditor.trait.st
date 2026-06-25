"
Define editor exclusive methods.
In general, all presenters including this trait should have a model including `PulsarTEditable`
"
Trait {
	#name : 'PulsarTEditor',
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'testing' }
PulsarTEditor >> isEditor [

	^ true
]
