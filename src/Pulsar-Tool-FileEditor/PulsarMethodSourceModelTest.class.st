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

{ #category : 'tests' }
PulsarMethodSourceModelTest >> testSourceCodeWithFString [
	| model |

	model := PulsarMethodSourceModel newEnvironment: nil entity: self class>>#fStringExample.
	
	self assert: model sourceCode equals: 'test [42]'
]
