Class {
	#name : 'DockActionCollector',
	#superclass : 'Object',
	#instVars : [
		'model',
		'context'
	],
	#category : 'Dock-Browser-Actions',
	#package : 'Dock-Browser',
	#tag : 'Actions'
}

{ #category : 'instance creation' }
DockActionCollector class >> collectFor: anObject [
	
	^ (self on: anObject) collect
]

{ #category : 'instance creation' }
DockActionCollector class >> on: anObject [

	^ self new 
		model: anObject;
		yourself
]

{ #category : 'building' }
DockActionCollector >> collect [
	| container |
	
	container := SpActionGroup new.
	self 
		register: self model class
		in: container.
	
	container entries: (container entries sorted: #priority ascending, #name ascending).
	container allCommands do: [ :each | each context: self context ]. 
	
	^ container
]

{ #category : 'accessing' }
DockActionCollector >> context [

	^ context ifNil: [ self model ]
]

{ #category : 'accessing' }
DockActionCollector >> context: aContext [

	context := aContext
]

{ #category : 'accessing' }
DockActionCollector >> model [

	^ model
]

{ #category : 'accessing' }
DockActionCollector >> model: anObject [

	model := anObject
]

{ #category : 'building' }
DockActionCollector >> register: aClass in: container [

	(Pragma allNamed: #dockActions from: aClass class to: SpPresenter) 
		do: [ :eachPragma | aClass perform: eachPragma methodSelector with: container ]
]
