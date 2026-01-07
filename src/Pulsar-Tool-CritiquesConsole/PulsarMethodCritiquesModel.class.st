Class {
	#name : 'PulsarMethodCritiquesModel',
	#superclass : 'PulsarCritiquesModel',
	#category : 'Pulsar-Tool-CritiquesConsole',
	#package : 'Pulsar-Tool-CritiquesConsole'
}

{ #category : 'testing' }
PulsarMethodCritiquesModel >> isScope: aSymbol [

	^ aSymbol == #class
]

{ #category : 'accessing' }
PulsarMethodCritiquesModel >> title [

	^ self currentModel
		ifNotNil:[ :aModel | 'Critiques on {1}' format: { aModel name } ]
		ifNil: [ 'No method selected' ]
]

{ #category : 'visiting' }
PulsarMethodCritiquesModel >> visitClassModel: aModel [

	^ aModel
]

{ #category : 'visiting' }
PulsarMethodCritiquesModel >> visitMethodModel: aModel [

	^ aModel asClassModel
]
