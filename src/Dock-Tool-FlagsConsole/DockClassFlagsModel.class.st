Class {
	#name : 'DockClassFlagsModel',
	#superclass : 'DockFlagsModel',
	#category : 'Dock-Tool-FlagsConsole',
	#package : 'Dock-Tool-FlagsConsole'
}

{ #category : 'private' }
DockClassFlagsModel >> calculateEnvironment [
	| env |
	
	env := SystemEnvironment new.
	
	self currentModel ifNotNil: [ :aModel |
		env 
			at: aModel entity name 
			put: aModel entity ].

	^ env
]

{ #category : 'testing' }
DockClassFlagsModel >> isScope: aSymbol [

	^ aSymbol == #class
]

{ #category : 'accessing' }
DockClassFlagsModel >> locationDescriptionFor: aFlag [

	^ aFlag locationDescriptionSelector
]

{ #category : 'accessing' }
DockClassFlagsModel >> title [

	^ self currentModel
		ifNotNil:[ :aModel | 'Flags on: {1} class' format: { aModel name } ]
		ifNil: [ 'Flags on: No class selected' ]
]

{ #category : 'visiting' }
DockClassFlagsModel >> visitClassModel: aModel [

	^ aModel
]

{ #category : 'visiting' }
DockClassFlagsModel >> visitMethodModel: aModel [

	^ aModel asClassModel
]
