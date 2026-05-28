Class {
	#name : 'PulsarRepositoryCommitModelTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
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

{ #category : 'tests' }
PulsarRepositoryCommitModelTest >> testAuthorInitialsOfSingleName [
	| model |

	model := PulsarRepositoryCommitModel new.

	self assert: (model authorInitialsOf: 'Esteban') equals: 'Es'.
	self assert: (model authorInitialsOf: 'a') equals: 'A'
]
