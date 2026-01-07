Class {
	#name : 'PulsarPackageFlagsModel',
	#superclass : 'PulsarFlagsModel',
	#category : 'Pulsar-Tool-FlagsConsole',
	#package : 'Pulsar-Tool-FlagsConsole'
}

{ #category : 'testing' }
PulsarPackageFlagsModel class >> isDefault [

	^ true
]

{ #category : 'private' }
PulsarPackageFlagsModel >> calculateEnvironment [
	| env |
	
	env := SystemEnvironment new.
	
	self currentModel ifNotNil: [ :aModel |
		"sometimes it happens that obsolete classes are still in the model. 
		 this is an error in the package organiser, but it forces me to do 
		 a reject like this" 
		aModel entity definedClasses 
			reject: [ :each | each isObsolete ]
			thenDo: [ :aClass | env at: aClass name put: aClass ] ].
	
	^ env
	
]

{ #category : 'testing' }
PulsarPackageFlagsModel >> isScope: aSymbol [

	^ aSymbol == #package
]

{ #category : 'accessing' }
PulsarPackageFlagsModel >> title [

	^ self currentModel 
		ifNotNil: [ :aModel | 'Flags on {1}' format: { aModel name } ]
		ifNil: [ 'No package selected' ]
]

{ #category : 'visiting' }
PulsarPackageFlagsModel >> visitClassModel: aModel [

	^ aModel asPackageModel
]

{ #category : 'visiting' }
PulsarPackageFlagsModel >> visitMethodModel: aModel [

	^ aModel asPackageModel
]
