"
Define en editable model (a model that corresponds to an editor panel).
It contains a `pulsarEditoClass` and its corresponding testing method.
"
Trait {
	#name : 'PulsarTModelEditable',
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'testing' }
PulsarTModelEditable >> hasPulsarEditor [

	^ self pulsarEditorClass isNotNil
]

{ #category : 'accessing' }
PulsarTModelEditable >> pulsarEditorClass [

	^ self required
]
