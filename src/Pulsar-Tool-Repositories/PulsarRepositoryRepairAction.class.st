"
I'm a repair option.
Repositories can be broken in several ways. My children will describe them and take the actions needed to perform the re-alignment of an image with its repository.
"
Class {
	#name : 'PulsarRepositoryRepairAction',
	#superclass : 'Object',
	#instVars : [
		'context',
		'successBlock',
		'repositoryModel'
	],
	#category : 'Pulsar-Tool-Repositories-Repair',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
PulsarRepositoryRepairAction class >> allAvailableFor: aRepository [
	^ ((self allSubclasses 
		select: [ :each | each isAvailableFor: aRepository ])
		sorted: [ :a :b | a order < b order ])
		collect: #new
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction class >> help [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction class >> icon [
	^ self subclassResponsibility
]

{ #category : 'testing' }
PulsarRepositoryRepairAction class >> isAbstract [

	^ self == PulsarRepositoryRepairAction
]

{ #category : 'testing' }
PulsarRepositoryRepairAction class >> isAvailableFor: aRepository [
	^ false
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction class >> order [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction class >> title [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction >> application [

	^ context application
]

{ #category : 'executing' }
PulsarRepositoryRepairAction >> basicExecute [
	self subclassResponsibility
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction >> context [

	^ context
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction >> context: aContext [

	context := aContext
]

{ #category : 'executing' }
PulsarRepositoryRepairAction >> execute [

	| result |
	
	self withErrorHandlingDo: [ 
		result := self basicExecute.
		self finishSuccess ].
	
	^ result.
]

{ #category : 'executing' }
PulsarRepositoryRepairAction >> executeWithContext: aContext [

	self context: aContext.
	^ self execute
]

{ #category : 'executing' }
PulsarRepositoryRepairAction >> executeWithContext: aContext model: aRepositoryModel [

	self context: aContext.
	self repositoryModel: aRepositoryModel.
	self execute
]

{ #category : 'private' }
PulsarRepositoryRepairAction >> fetchAllRemotes [
	| remotes |
	
	self context scheduleJob: [ :statusbar |
		[ 
			statusbar pushMessage: 'Fetching remotes...'.
			remotes := self repository remotes.
			remotes withIndexDo: [ :each :index |
				statusbar popMessage.
				statusbar pushMessage: ('Fetching incoming commits of {1}' format: { each name }).
				self repository fetchFrom: each ] ] 
		ensure: [ 
			statusbar popMessage ] ]
]

{ #category : 'private' }
PulsarRepositoryRepairAction >> finishSuccess [

	successBlock ifNotNil: #value
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction >> help [ 
	^ self class help
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction >> icon [
	^ self class icon
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction >> onSuccess: aBlock [ 
	"Some actions need to execute something right after finish. Like a refresh of panels, etc.
	 If a block is defined here, it will be evaluated right after the command is executed, if 
	 there are no exceptions."
	
	successBlock := aBlock
]

{ #category : 'private' }
PulsarRepositoryRepairAction >> notifyRepositoryModified [

	self application resendAnnouncement: (PulsarRepositoryModified newValue: self repositoryModel)
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction >> repository [
	^ self repositoryModel entity
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction >> repositoryModel [
	^ repositoryModel
]

{ #category : 'private' }
PulsarRepositoryRepairAction >> repositoryModel: anObject [
	repositoryModel := anObject
]

{ #category : 'accessing' }
PulsarRepositoryRepairAction >> title [
	^ self class title
]

{ #category : 'enumerating' }
PulsarRepositoryRepairAction >> withErrorHandlingDo: aBlock [
	aBlock
		on: IceError, IceWarning
		do: [ :e | 
			e acceptError: (IceTipInteractiveErrorVisitor 
				newContext: self context 
				repository: self repository) ]
]
