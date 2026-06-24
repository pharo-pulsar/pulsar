Extension { #name : 'StExtensionDependency' }

{ #category : '*Pulsar-Browser' }
StExtensionDependency >> browsableEntityOn: anEnvironmentModel [

	^ PvMethodModel newEnvironment: anEnvironmentModel entity: self method
]
