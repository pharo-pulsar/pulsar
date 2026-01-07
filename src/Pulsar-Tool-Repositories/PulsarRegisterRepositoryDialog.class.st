Class {
	#name : 'PulsarRegisterRepositoryDialog',
	#superclass : 'IceTipRegisterRepositoryDialogPresenter',
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'actions' }
PulsarRegisterRepositoryDialog >> doAccept [
	| newRepository |
	
	self selectedType validate.
	
	self isEditing ifTrue: [ 
		self selectedType repository: repository ].
	newRepository := self selectedType newRepository.
	self isEditing ifFalse: [ 
		newRepository register ].
	
	acceptBlock ifNotNil: [ acceptBlock cull: self ]
]
