Extension { #name : 'PulsarApplication' }

{ #category : '*Pulsar-Tool-FileEditor' }
PulsarApplication >> fileTypeIconProvider [
	<iconProvider>
	
	^ PulsarVSCodeFileTypeIconProvider new
		addLocation: self resourcesDir / 'FileTypes' / 'svg';
		yourself
]
