Extension { #name : 'StDependencyFromClass' }

{ #category : '*Pulsar-Browser' }
StDependencyFromClass >> browsableEntityOn: anEnvironmentModel [

	^ PvClassModel newEnvironment: anEnvironmentModel entity: self theClass
]
