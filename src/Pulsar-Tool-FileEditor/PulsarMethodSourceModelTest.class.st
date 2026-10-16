Class {
	#name : 'PulsarMethodSourceModelTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Tool-FileEditor-Model',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Model'
}

{ #category : 'tests' }
PulsarMethodSourceModelTest >> fStringExample [

	^ f'test [42]'
]

{ #category : 'as yet unclassified' }
PulsarMethodSourceModelTest >> fStringNode [
    "Answer the f-string node of my method, if any."
    ^ self entity ast
        withAllChildren
        detect: [ :node |
            (node respondsTo: #isFStringNode)
                and: [ node isFStringNode ] ]
        ifNone: [ nil ]
]

{ #category : 'accessing' }
PulsarMethodSourceModelTest >> sourceCode [

	^ self fStringNode
		ifNotNil: [ :fStringNode |
			fStringNode sourceText
        			copyFrom: 3
        			to: fStringNode sourceText size - 1 ]
	  	ifNil: [ 
			self entity literals 
				detect: [ :each | each isString ] 
				ifNone: [ '' ] ].
]

{ #category : 'tests' }
PulsarMethodSourceModelTest >> testSourceCodeWithFString [
	| model |

	model := PulsarMethodSourceModel newEnvironment: nil entity: self class>>#fStringExample.
	
	self assert: model sourceCode equals: 'test [42]'
]
