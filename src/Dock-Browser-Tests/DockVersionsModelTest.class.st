Class {
	#name : 'DockVersionsModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'instance creation' }
DockVersionsModelTest >> newVersionModelOn: aMethod [

	^ DockVersionsModel 
		newEnvironment: self environmentModel 
		entity: aMethod
]

{ #category : 'tests' }
DockVersionsModelTest >> testRevertTo [
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
