Class {
	#name : #PvActionCollector,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'Perspective-Command-Base'
}

{ #category : #'instance creation' }
PvActionCollector class >> collectFor: anObject [
	
	^ (self on: anObject) collect
]

{ #category : #'instance creation' }
PvActionCollector class >> on: anObject [

	^ self new 
		model: anObject;
		yourself
]

{ #category : #building }
PvActionCollector >> collect [
	| container |
	
	container := PvActionGroup new.
	self 
		register: self model class
		in: container.
	^ container asSpecWithContext: self model
]

{ #category : #accessing }
PvActionCollector >> model [

	^ model
]

{ #category : #accessing }
PvActionCollector >> model: anObject [

	model := anObject
]

{ #category : #building }
PvActionCollector >> register: aClass in: container [

	(Pragma allNamed: #perspectiveActions from: aClass class to: PvPresenter) 
		do: [ :eachPragma | aClass perform: eachPragma methodSelector with: container ]
]
