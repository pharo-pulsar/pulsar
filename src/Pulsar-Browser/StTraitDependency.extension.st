Extension { #name : 'StTraitDependency' }

{ #category : '*Pulsar-Browser' }
StTraitDependency >> browsableEntityOn: anEnvironmentModel [

	^ PvClassModel newEnvironment: anEnvironmentModel entity: self theClass
]
