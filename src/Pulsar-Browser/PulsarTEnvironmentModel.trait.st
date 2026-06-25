"
A base for all environment-dependent models of the system. 
This ones **are not** `PulsarTModel` directly because they are not directly selectable. E.g. a `PulsarMultiProjectModel` depends on an `envirnmentModel` but is not actionable outside its own context (the *project view*). 

## Important vocabulary

- `environmentModel` -> provides access to the environment of this browser.
"
Trait {
	#name : 'PulsarTEnvironmentModel',
	#instVars : [
		'environmentModel'
	],
	#category : 'Pulsar-Browser-Base',
	#package : 'Pulsar-Browser',
	#tag : 'Base'
}

{ #category : 'instance creation' }
PulsarTEnvironmentModel classSide >> newEnvironment: aModel [

	^ self basicNew 
		environmentModel: aModel;
		initialize;
		yourself.
]

{ #category : 'instance creation' }
PulsarTEnvironmentModel classSide >> on: aModel [

	^ self newEnvironment: aModel
]

{ #category : 'accessing' }
PulsarTEnvironmentModel >> environmentModel [

	^ environmentModel
]

{ #category : 'accessing' }
PulsarTEnvironmentModel >> environmentModel: aModel [

	environmentModel := aModel
]
