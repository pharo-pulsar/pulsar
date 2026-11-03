Class {
	#name : 'PulsarEnvironmentContractTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'running' }
PulsarEnvironmentContractTest >> environment [

	^ PulsarModelTestEnvironment current
]

{ #category : 'tests' }
PulsarEnvironmentContractTest >> testAllBaselinesNotEmpty [

	self assert: self environment allBaselines isNotEmpty
]

{ #category : 'tests' }
PulsarEnvironmentContractTest >> testAllClassesAndTraitsIncludesObject [

	| environment |
	environment := self environment.
	self assert: (environment allClassesAndTraits anySatisfy: [ :each |
		each name = 'Object' ])
]

{ #category : 'tests' }
PulsarEnvironmentContractTest >> testAllImplementorsOf [

	| environment implementors |
	environment := self environment.
	implementors := environment allImplementorsOf: #printString.
	self assert: implementors isNotEmpty.
	self assert: (implementors allSatisfy: [ :each | each selector = #printString ])
]

{ #category : 'tests' }
PulsarEnvironmentContractTest >> testAllPackagesNotEmpty [

	self assert: self environment allPackages isNotEmpty
]

{ #category : 'tests' }
PulsarEnvironmentContractTest >> testClassIdentityIsConsistent [

	self assert: (self environment classNamed: #Object)
		equals: (self environment classNamed: #Object)
]

{ #category : 'tests' }
PulsarEnvironmentContractTest >> testClassNamed [

	self assert: (self environment classNamed: #Object) name equals: 'Object'
]

{ #category : 'tests' }
PulsarEnvironmentContractTest >> testClassesMatching [

	| environment names |
	environment := self environment.
	names := (environment classesMatching: 'Object') collect: [ :each | each name ].
	self assert: (names includes: 'Object')
]

{ #category : 'tests' }
PulsarEnvironmentContractTest >> testDefinitionString [

	self assert: ((self environment definitionStringOf: (self environment classNamed: #Object))
		includesSubstring: 'Object')
]

{ #category : 'tests' }
PulsarEnvironmentContractTest >> testLoadedProjectsAreDescriptors [

	self assert: (self environment loadedProjects allSatisfy: [ :each |
		each isKindOf: PulsarLoadedProject ])
]

{ #category : 'tests' }
PulsarEnvironmentContractTest >> testNameIsNotEmpty [

	self assert: self environment name isNotEmpty
]

{ #category : 'tests' }
PulsarEnvironmentContractTest >> testPackageRoundTrip [

	| environment package |
	environment := self environment.
	self assert: (environment hasPackageNamed: 'Kernel').
	package := environment packageNamed: 'Kernel'.
	self assert: package name equals: 'Kernel'.
	self deny: (environment hasPackageNamed: 'ThisPackageDoesNotExist')
]
