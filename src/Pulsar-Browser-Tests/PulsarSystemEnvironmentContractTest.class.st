Class {
	#name : 'PulsarSystemEnvironmentContractTest',
	#superclass : 'PulsarEnvironmentContractTest',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'testing' }
PulsarSystemEnvironmentContractTest class >> shouldInheritSelectors [

	^ true
]

{ #category : 'running' }
PulsarSystemEnvironmentContractTest >> environment [

	^ PulsarSystemEnvironment new
]

{ #category : 'tests' }
PulsarSystemEnvironmentContractTest >> testClassNamedAnswersTheRealClass [

	self assert: (self environment classNamed: #Object) == Object
]

{ #category : 'tests' }
PulsarSystemEnvironmentContractTest >> testCompilerForClass [

	self assert: (self environment compilerForClass: Object) notNil
]

{ #category : 'tests' }
PulsarSystemEnvironmentContractTest >> testLocalClassOfIdentity [

	self assert: (self environment localClassOf: Object) == Object
]

{ #category : 'tests' }
PulsarSystemEnvironmentContractTest >> testPackageNamedAnswersTheRealPackage [

	self assert: (self environment packageNamed: 'Kernel')
		== (PackageOrganizer default packageNamed: 'Kernel')
]

{ #category : 'tests' }
PulsarSystemEnvironmentContractTest >> testUnknownPackageRaisesKeyNotFound [

	self
		should: [ self environment packageNamed: 'ThisPackageDoesNotExist' ]
		raise: KeyNotFound
]
