Class {
	#name : 'DockPackageFlagsModel',
	#superclass : 'DockFlagsModel',
	#category : 'Dock-Tool-FlagsConsole',
	#package : 'Dock-Tool-FlagsConsole'
}

{ #category : 'testing' }
DockPackageFlagsModel class >> isDefault [

	^ true
]

{ #category : 'private' }
DockPackageFlagsModel >> calculateEnvironment [
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
DockPackageFlagsModel >> isScope: aSymbol [

	^ aSymbol == #package
]

{ #category : 'accessing' }
DockPackageFlagsModel >> title [

	^ self currentModel 
		ifNotNil: [ :aModel | 'Flags on {1} package' format: { aModel name } ]
		ifNil: [ 'No package selected' ]
]

{ #category : 'visiting' }
DockPackageFlagsModel >> visitClassModel: aModel [

	^ aModel asPackageModel
]

{ #category : 'visiting' }
DockPackageFlagsModel >> visitMethodModel: aModel [

	^ aModel asPackageModel
]
