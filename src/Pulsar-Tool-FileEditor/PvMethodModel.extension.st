Extension { #name : 'PvMethodModel' }

{ #category : '*Pulsar-Tool-FileEditor' }
PvMethodModel >> editorSource: aCollection [
	<pulsarMethodEditor>
	
	(self entity hasPragmaNamed: #pulsarSourceEditor:) ifFalse: [ ^ self ].
	aCollection add: (
		PulsarMethodSourceModel 
			newEnvironment: self environmentModel 
			entity: self entity)
]
