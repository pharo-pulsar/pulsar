Class {
	#name : 'PulsarClassFlagsModel',
	#superclass : 'PulsarFlagsModel',
	#category : 'Pulsar-Tool-FlagsConsole',
	#package : 'Pulsar-Tool-FlagsConsole'
}

{ #category : 'private' }
PulsarClassFlagsModel >> calculateEnvironment [
	| env |
	
	env := SystemEnvironment new.
	
	self currentModel ifNotNil: [ :aModel |
		env 
			at: aModel entity name 
			put: aModel entity ].

	^ env
]

{ #category : 'testing' }
PulsarClassFlagsModel >> isScope: aSymbol [

	^ aSymbol == #class
]

{ #category : 'accessing' }
PulsarClassFlagsModel >> locationDescriptionFor: aFlag [

	^ aFlag locationDescriptionSelector
]

{ #category : 'accessing' }
PulsarClassFlagsModel >> title [

	^ self currentModel
		ifNotNil:[ :aModel | 'Flags on {1}' format: { aModel name } ]
		ifNil: [ 'No class selected' ]
]

{ #category : 'visiting' }
PulsarClassFlagsModel >> visitClassModel: aModel [

	^ aModel
]

{ #category : 'visiting' }
PulsarClassFlagsModel >> visitMethodModel: aModel [

	^ aModel asClassModel
]
