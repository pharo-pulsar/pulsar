Class {
	#name : 'PulsarVersionsModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'instance creation' }
PulsarVersionsModelTest >> newVersionModelOn: aMethod [

	^ PulsarVersionsModel 
		newEnvironment: self environmentModel 
		entity: aMethod
]

{ #category : 'tests' }
PulsarVersionsModelTest >> testRevertTo [
	| model |
	
	self class compile: 'aMethod ^ nil' classified: 'REMOVEME'.
	self class compile: 'aMethod ^ 42' classified: 'REMOVEME'.
	
	[ 
		model := self newVersionModelOn: self class >> #aMethod.
		model revertTo: model versions last.
		self 
			assert: (self class >> #aMethod) sourceCode 
			equals: 'aMethod ^ nil'. 
		self assert: model entity equals: (self class >> #aMethod).
		self assert: model versions size equals: 3.
		self assert: model ringDefinition sourceCode equals: 'aMethod ^ nil' ] 
	ensure: [ 
		(self class >> #aMethod) removeFromSystem ]
]
