Class {
	#name : 'PulsarRepositoryCommitModelTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'tests' }
PulsarRepositoryCommitModelTest >> testAuthorInitialsOf [
	| model |
	
	model := PulsarRepositoryCommitModel new.
	
	self assert: (model authorInitialsOf: 'Esteban Lorenzano') equals: 'EL'.
	self assert: (model authorInitialsOf: 'Esteban.Lorenzano') equals: 'EL'.
	self assert: (model authorInitialsOf: 'Esteban-Lorenzano') equals: 'EL'.
	self assert: (model authorInitialsOf: 'esteban lorenzano') equals: 'EL'.
	self assert: (model authorInitialsOf: 'Estebanlorenzano') equals: 'Es'.
	self assert: (model authorInitialsOf: 'e') equals: 'E'.
	self assert: (model authorInitialsOf: 'EstebanLorenzano') equals: 'EL'.
]
