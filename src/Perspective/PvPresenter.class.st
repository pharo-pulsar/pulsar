"
A base for all perspective presenters.
"
Class {
	#name : 'PvPresenter',
	#superclass : 'SgaPresenter',
	#traits : 'PvTScripting',
	#classTraits : 'PvTScripting classTrait',
	#category : 'Perspective-View',
	#package : 'Perspective',
	#tag : 'View'
}

{ #category : 'initialization' }
PvPresenter >> addGlobalActionsTo: aWindowPresenter [
	
	self globalActions 
		ifNotNil: [ :aGroup | aWindowPresenter actions: aGroup ]
]

{ #category : 'private' }
PvPresenter >> buildIcon: aBlock [
	| compositeIcon |
	
	compositeIcon := PvCompositeIcon new.
	aBlock value: compositeIcon.
	^ compositeIcon buildOn: self application
]

{ #category : 'private' }
PvPresenter >> colorNamed: aString [

	^ self application colorNamed: aString
]

{ #category : 'initialization' }
PvPresenter >> globalActions [

	^ nil
]

{ #category : 'testing' }
PvPresenter >> isCloseable [

	self subclassResponsibility
]

{ #category : 'testing' }
PvPresenter >> isEditor [

	^ false
]

{ #category : 'initialization' }
PvPresenter >> settings [

	^ self application settings
]

{ #category : 'accessing' }
PvPresenter >> spotterTitle [

	self subclassResponsibility
]
