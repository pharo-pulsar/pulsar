Extension { #name : 'StInheritanceDependency' }

{ #category : '*Pulsar-Browser' }
StInheritanceDependency >> browsableEntityOn: anEnvironmentModel [

	^ PvClassModel newEnvironment: anEnvironmentModel entity: self theClass
]
