Trait {
	#name : 'PulsarTEditable',
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'testing' }
PulsarTEditable >> hasPulsarEditor [

	^ self pulsarEditorClass isNotNil
]

{ #category : 'accessing' }
PulsarTEditable >> pulsarEditorClass [

	^ self required
]
