Class {
	#name : 'DockRepositoryCommitModelTest',
	#superclass : 'TestCase',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'tests' }
DockRepositoryCommitModelTest >> testAuthorInitialsOf [
	| model |
	
	model := DockRepositoryCommitModel new.
	
	self assert: (model authorInitialsOf: 'Esteban Lorenzano') equals: 'EL'.
	self assert: (model authorInitialsOf: 'Esteban.Lorenzano') equals: 'EL'.
	self assert: (model authorInitialsOf: 'Esteban-Lorenzano') equals: 'EL'.
	self assert: (model authorInitialsOf: 'esteban lorenzano') equals: 'EL'.
	self assert: (model authorInitialsOf: 'Estebanlorenzano') equals: 'Es'.
	self assert: (model authorInitialsOf: 'e') equals: 'E'.
	self assert: (model authorInitialsOf: 'EstebanLorenzano') equals: 'EL'.
]
