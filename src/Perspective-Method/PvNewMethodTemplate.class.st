Class {
	#name : #PvNewMethodTemplate,
	#superclass : #Object,
	#instVars : [
		'parentModel'
	],
	#category : #'Perspective-Method-Model'
}

{ #category : #accessing }
PvNewMethodTemplate >> category [

	^ #'as yet unclassified'
]

{ #category : #testing }
PvNewMethodTemplate >> isDoIt [
	
	^ false
]

{ #category : #testing }
PvNewMethodTemplate >> isTestMethod [

	^ false
]

{ #category : #accessing }
PvNewMethodTemplate >> methodClass [

	^ self parentModel entity
]

{ #category : #accessing }
PvNewMethodTemplate >> parentModel [

	^ parentModel
]

{ #category : #accessing }
PvNewMethodTemplate >> parentModel: anObject [

	parentModel := anObject
]

{ #category : #accessing }
PvNewMethodTemplate >> selector [

	^ #'new method'
]

{ #category : #accessing }
PvNewMethodTemplate >> sourceCode [

	^ self sourceCodeTemplate
]

{ #category : #compiling }
PvNewMethodTemplate >> sourceCodeTemplate [

	^ self methodClass sourceCodeTemplate
]
