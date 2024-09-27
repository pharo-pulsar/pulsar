Class {
	#name : 'PvSpecCommandGroup',
	#superclass : 'SpCommandGroup',
	#category : 'Perspective-Command-Base',
	#package : 'Perspective',
	#tag : 'Command-Base'
}

{ #category : 'registering' }
PvSpecCommandGroup >> actionsFor: anId [
	
	^ self decoratedGroup actionsFor: anId
]

{ #category : 'registering' }
PvSpecCommandGroup >> actionsForAll: aCollection [ 
	
	^ self decoratedGroup actionsForAll: aCollection
]

{ #category : 'converting' }
PvSpecCommandGroup >> asSpecWithContext: aContext [
	
	self decoratedGroup 
		entries: (self decoratedGroup entries collect: [ :each | each asSpecWithContext: aContext])
]

{ #category : 'testing' }
PvSpecCommandGroup >> hasEntries [
	
	^ self decoratedGroup hasEntries
]

{ #category : 'accessing' }
PvSpecCommandGroup >> id [

	^ self decoratedGroup id
]

{ #category : 'accessing' }
PvSpecCommandGroup >> id: aSymbol [

	self decoratedGroup id: aSymbol
]

{ #category : 'accessing' }
PvSpecCommandGroup >> priority [

	^ self decoratedGroup priority
]

{ #category : 'accessing' }
PvSpecCommandGroup >> priority: aNumber [

	self decoratedGroup priority: aNumber
]

{ #category : 'registering - actions' }
PvSpecCommandGroup >> registerAction: anAction [

	self decoratedGroup registerAction: anAction
]
