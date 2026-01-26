Class {
	#name : 'PvProtocolModel',
	#superclass : 'PvBaseModel',
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvProtocolModel class >> all [

	^ self 
		newEnvironment: nil 
		entity: Protocol new
]

{ #category : 'accessing' }
PvProtocolModel >> basicName [

	^ self entity name
]

{ #category : 'accessing - ui' }
PvProtocolModel >> iconName [

	self isExtension ifTrue: [ ^ #protocolExtension ].
	self isPrivate ifTrue: [ ^ #protocolPrivate ].
	self isProtected ifTrue: [ ^ #protocolProtected ].

	^ nil
]

{ #category : 'testing' }
PvProtocolModel >> isExtension [

	^ self basicName first = $*
]

{ #category : 'testing' }
PvProtocolModel >> isPrivate [
	
	^ self basicName asLowercase beginsWith: 'private'
]

{ #category : 'testing' }
PvProtocolModel >> isProtected [
	| lowercaseName |
	
	lowercaseName := self basicName asLowercase.
	^ #('initial' 'class initial' 'releaz' 'releas' 'finali')
		anySatisfy: [ :each | lowercaseName beginsWith: each ]
]

{ #category : 'testing' }
PvProtocolModel >> isUnclassified [
	
	^ self entity isUnclassifiedProtocol
]

{ #category : 'testing' }
PvProtocolModel >> isVirtual [

	^ false
]

{ #category : 'accessing' }
PvProtocolModel >> name [

	self isExtension 
		ifTrue: [ ^ self basicName allButFirst ].
	
	^ self basicName
]

{ #category : 'accessing' }
PvProtocolModel >> numberOfMethods [

	^ self selectors size
]

{ #category : 'actions' }
PvProtocolModel >> renameProtocolTo: aName [

	self entity owningClass 
		renameProtocol: self name 
		as: aName
]

{ #category : 'accessing' }
PvProtocolModel >> selectors [
	
	^ self entity methodSelectors
]
