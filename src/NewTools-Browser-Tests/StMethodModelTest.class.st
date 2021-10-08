Class {
	#name : #StMethodModelTest,
	#superclass : #TestCase,
	#instVars : [
		'classFactory',
		'class',
		'model',
		'method'
	],
	#category : #'NewTools-Browser-Tests'
}

{ #category : #running }
StMethodModelTest >> setUp [
	
	super setUp.
	classFactory := ClassFactoryForTestCase new. 
	class := classFactory newClass.
	class compile: 'test1 ^ self' classified: 'accessing'.
	method := class >> #test1.
	model := StMethodModel newMethod: method
]

{ #category : #running }
StMethodModelTest >> tearDown [
	
	classFactory cleanUp. 
	super tearDown
	
]

{ #category : #tests }
StMethodModelTest >> testColorName [

	self assert: model colorName equals: nil
]

{ #category : #tests }
StMethodModelTest >> testCompileNotifying [
	| source |

	source := '{1} ^ 42' format: { method selector }.
	self deny: method sourceCode equals: source.
	model compile: source notifying: nil.
	self assert: method sourceCode equals: source
]

{ #category : #tests }
StMethodModelTest >> testIconName [

	self assert: model iconName equals: #blank
]

{ #category : #tests }
StMethodModelTest >> testIconNameFlag [

	class compileSilently: 'methodWithFlag self flag: #ICON' classified: 'accessing'.
	model := StMethodModel newMethod: class>>#methodWithFlag.
	
	self assert: model iconName equals: #flagIcon
]

{ #category : #tests }
StMethodModelTest >> testSourceCode [

	self 
		assert: model sourceCode
		equals: method sourceCode
]
