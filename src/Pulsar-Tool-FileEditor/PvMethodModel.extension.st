Extension { #name : 'PvMethodModel' }

{ #category : '*Pulsar-Tool-FileEditor' }
PvMethodModel >> editorFFI: aCollection [

	<pulsarMethodEditor>
	self ffiCallArrayNode ifNil: [ ^ self ].
	aCollection add: (PulsarFFIModel newEnvironment: self environmentModel entity: self entity)
]
