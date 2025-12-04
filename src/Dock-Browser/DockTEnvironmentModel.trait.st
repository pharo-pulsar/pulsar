"
A base for all environment-dependent models of the system. 
This ones **are not** `DockTModel` directly because they are not directly selectable. E.g. a `DockMultiProjectModel` depends on an `envirnmentModel` but is not actionable outside its own context (the *project view*). 

## Important vocabulary

- `environmentModel` -> provides access to the environment of this browser.
"
Trait {
	#name : 'DockTEnvironmentModel',
	#instVars : [
		'environmentModel'
	],
	#category : 'Dock-Browser-Base',
	#package : 'Dock-Browser',
	#tag : 'Base'
}

{ #category : 'instance creation' }
DockTEnvironmentModel classSide >> newEnvironment: aModel [

	^ self basicNew 
		environmentModel: aModel;
		initialize;
		yourself.
]

{ #category : 'accessing' }
DockTEnvironmentModel >> environmentModel [

	^ environmentModel
]

{ #category : 'accessing' }
DockTEnvironmentModel >> environmentModel: aModel [

	environmentModel := aModel
]
