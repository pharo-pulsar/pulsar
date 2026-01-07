Trait {
	#name : 'PulsarTEditable',
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing' }
PulsarTEditable >> dockEditorClass [

	^ self required
]

{ #category : 'testing' }
PulsarTEditable >> hasPulsarEditor [

	^ self dockEditorClass isNotNil
]
