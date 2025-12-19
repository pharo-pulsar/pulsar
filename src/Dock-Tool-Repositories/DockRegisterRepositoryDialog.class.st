Class {
	#name : 'DockRegisterRepositoryDialog',
	#superclass : 'IceTipRegisterRepositoryDialogPresenter',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'actions' }
DockRegisterRepositoryDialog >> doAccept [
	| newRepository |
	
	self selectedType validate.
	
	self isEditing ifTrue: [ 
		self selectedType repository: repository ].
	newRepository := self selectedType newRepository.
	self isEditing ifFalse: [ 
		newRepository register ].
	
	acceptBlock ifNotNil: [ acceptBlock cull: self ]
]
