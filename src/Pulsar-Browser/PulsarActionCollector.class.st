Class {
	#name : 'PulsarActionCollector',
	#superclass : 'Object',
	#instVars : [
		'model',
		'context'
	],
	#category : 'Pulsar-Browser-Actions',
	#package : 'Pulsar-Browser',
	#tag : 'Actions'
}

{ #category : 'instance creation' }
PulsarActionCollector class >> collectFor: anObject [
	
	^ (self on: anObject) collect
]

{ #category : 'instance creation' }
PulsarActionCollector class >> on: anObject [

	^ self new 
		model: anObject;
		yourself
]

{ #category : 'building' }
PulsarActionCollector >> collect [
	| container |
	
	container := SpActionGroup new.
	self 
		register: self model
		in: container.
	
	container entries: (container entries sorted: #priority ascending, #name ascending).
	container allCommands do: [ :each | each context: self context ]. 
	
	^ container
]

{ #category : 'accessing' }
PulsarActionCollector >> context [

	^ context ifNil: [ self model ]
]

{ #category : 'accessing' }
PulsarActionCollector >> context: aContext [

	context := aContext
]

{ #category : 'accessing' }
PulsarActionCollector >> model [

	^ model
]

{ #category : 'accessing' }
PulsarActionCollector >> model: anObject [

	model := anObject
]

{ #category : 'building' }
PulsarActionCollector >> register: aModel in: container [

	"instance side"
	(Pragma allNamed: #dockActions from: aModel class to: SpPresenter) 
		do: [ :eachPragma | aModel perform: eachPragma methodSelector with: container ].
	"class side"
	(Pragma allNamed: #dockActions from: aModel class class to: SpPresenter) 
		do: [ :eachPragma | aModel class perform: eachPragma methodSelector with: container ].
]
