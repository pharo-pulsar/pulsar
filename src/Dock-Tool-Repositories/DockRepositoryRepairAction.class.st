"
I'm a repair option.
Repositories can be broken in several ways. My children will describe them and take the actions needed to perform the re-alignment of an image with its repository.
"
Class {
	#name : 'DockRepositoryRepairAction',
	#superclass : 'Object',
	#instVars : [
		'context',
		'successBlock',
		'repositoryModel'
	],
	#category : 'Dock-Tool-Repositories-Repair',
	#package : 'Dock-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
DockRepositoryRepairAction class >> allAvailableFor: aRepository [
	^ ((self allSubclasses 
		select: [ :each | each isAvailableFor: aRepository ])
		sorted: [ :a :b | a order < b order ])
		collect: #new
]

{ #category : 'accessing' }
DockRepositoryRepairAction class >> help [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
DockRepositoryRepairAction class >> icon [
	^ self subclassResponsibility
]

{ #category : 'testing' }
DockRepositoryRepairAction class >> isAbstract [

	^ self == IceTipRepairAction
]

{ #category : 'testing' }
DockRepositoryRepairAction class >> isAvailableFor: aRepository [
	^ false
]

{ #category : 'accessing' }
DockRepositoryRepairAction class >> order [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
DockRepositoryRepairAction class >> title [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
DockRepositoryRepairAction >> application [

	^ context application
]

{ #category : 'executing' }
DockRepositoryRepairAction >> basicExecute [
	self subclassResponsibility
]

{ #category : 'accessing' }
DockRepositoryRepairAction >> context [

	^ context
]

{ #category : 'accessing' }
DockRepositoryRepairAction >> context: aContext [

	context := aContext
]

{ #category : 'executing' }
DockRepositoryRepairAction >> execute [

	| result |
	
	self withErrorHandlingDo: [ 
		result := self basicExecute.
		self finishSuccess ].
	
	^ result.
]

{ #category : 'executing' }
DockRepositoryRepairAction >> executeWithContext: aContext [

	self context: aContext.
	^ self execute
]

{ #category : 'executing' }
DockRepositoryRepairAction >> executeWithContext: aContext model: aRepositoryModel [

	self context: aContext.
	self repositoryModel: aRepositoryModel.
	self execute
]

{ #category : 'private' }
DockRepositoryRepairAction >> fetchAllRemotes [
	| remotes |
	remotes := self repository remotes.
	UIManager default informUserDuring: [ :bar | 
		bar label: 'Fetching incoming commits'.
		bar max: remotes size.
		bar value: 1.
		remotes withIndexDo: [ :each :index |
			bar label: ('Fetching incoming commits of {1}' format: {each name}).
			bar value: index + 1.
			self repository fetchFrom: each ] ].	
]

{ #category : 'private' }
DockRepositoryRepairAction >> finishSuccess [

	successBlock ifNotNil: #value
]

{ #category : 'accessing' }
DockRepositoryRepairAction >> help [ 
	^ self class help
]

{ #category : 'accessing' }
DockRepositoryRepairAction >> icon [
	^ self class icon
]

{ #category : 'accessing' }
DockRepositoryRepairAction >> onSuccess: aBlock [ 
	"Some actions need to execute something right after finish. Like a refresh of panels, etc.
	 If a block is defined here, it will be evaluated right after the command is executed, if 
	 there are no exceptions."
	
	successBlock := aBlock
]

{ #category : 'accessing' }
DockRepositoryRepairAction >> repository [
	^ self repositoryModel entity
]

{ #category : 'accessing' }
DockRepositoryRepairAction >> repositoryModel [
	^ repositoryModel
]

{ #category : 'private' }
DockRepositoryRepairAction >> repositoryModel: anObject [
	repositoryModel := anObject
]

{ #category : 'accessing' }
DockRepositoryRepairAction >> title [
	^ self class title
]

{ #category : 'enumerating' }
DockRepositoryRepairAction >> withErrorHandlingDo: aBlock [
	aBlock
		on: IceError, IceWarning
		do: [ :e | 
			e acceptError: (IceTipInteractiveErrorVisitor 
				newContext: self context 
				repository: self repository) ]
]
