Class {
	#name : 'DockMethodCritiquesModel',
	#superclass : 'DockCritiquesModel',
	#category : 'Dock-Tool-CritiquesConsole',
	#package : 'Dock-Tool-CritiquesConsole'
}

{ #category : 'testing' }
DockMethodCritiquesModel >> isScope: aSymbol [

	^ aSymbol == #class
]

{ #category : 'accessing' }
DockMethodCritiquesModel >> title [

	^ self currentModel
		ifNotNil:[ :aModel | 'Critiques on {1}' format: { aModel name } ]
		ifNil: [ 'No method selected' ]
]

{ #category : 'visiting' }
DockMethodCritiquesModel >> visitClassModel: aModel [

	^ aModel
]

{ #category : 'visiting' }
DockMethodCritiquesModel >> visitMethodModel: aModel [

	^ aModel asClassModel
]
