Extension { #name : 'StReferenceDependency' }

{ #category : '*Pulsar-Browser' }
StReferenceDependency >> browsableEntityOn: anEnvironmentModel [

	^ PvMethodModel newEnvironment: anEnvironmentModel entity: self method
]
