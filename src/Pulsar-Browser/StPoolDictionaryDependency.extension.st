Extension { #name : 'StPoolDictionaryDependency' }

{ #category : '*Pulsar-Browser' }
StPoolDictionaryDependency >> browsableEntityOn: anEnvironmentModel [

	^ PvClassModel newEnvironment: anEnvironmentModel entity: self theClass
]
