Class {
	#name : 'PvNewMethodTemplate',
	#superclass : 'Object',
	#instVars : [
		'environmentModel',
		'parentModel',
		'protocol',
		'isClassSide'
	],
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvNewMethodTemplate class >> newEnvironmentModel: anEnvironmentModel parent: aClassModel [

	^ self new 
		environmentModel: anEnvironmentModel; 
		parentModel: aClassModel;
		yourself
]

{ #category : 'accessing' }
PvNewMethodTemplate >> beForClassSide [

	isClassSide := true
]

{ #category : 'accessing' }
PvNewMethodTemplate >> category [

	^ #'as yet unclassified'
]

{ #category : 'accessing' }
PvNewMethodTemplate >> environmentModel [
	
	^ environmentModel
]

{ #category : 'accessing' }
PvNewMethodTemplate >> environmentModel: anEnvironmentModel [
	
	environmentModel := anEnvironmentModel
]

{ #category : 'initialization' }
PvNewMethodTemplate >> initialize [

	super initialize.
	isClassSide := false
]

{ #category : 'testing' }
PvNewMethodTemplate >> isClassSide [

	^ isClassSide
]

{ #category : 'testing' }
PvNewMethodTemplate >> isDoIt [
	
	^ false
]

{ #category : 'testing' }
PvNewMethodTemplate >> isTestMethod [

	^ false
]

{ #category : 'accessing' }
PvNewMethodTemplate >> methodClass [
	
	^ self isClassSide 
		ifTrue: [ self parentModel classSide ]
		ifFalse: [ self parentModel instanceSide ]
]

{ #category : 'accessing' }
PvNewMethodTemplate >> parentModel [

	^ parentModel
]

{ #category : 'accessing' }
PvNewMethodTemplate >> parentModel: anObject [

	parentModel := anObject
]

{ #category : 'accessing' }
PvNewMethodTemplate >> protocol [
	
	^ protocol ifNil: [ protocol := Protocol new ]
]

{ #category : 'accessing' }
PvNewMethodTemplate >> protocol: aProtocolString [

	protocol := aProtocolString
]

{ #category : 'accessing' }
PvNewMethodTemplate >> selector [

	^ #'new method'
]

{ #category : 'accessing' }
PvNewMethodTemplate >> sourceCode [

	^ self sourceCodeTemplate
]

{ #category : 'compiling' }
PvNewMethodTemplate >> sourceCodeTemplate [

	^ self methodClass sourceCodeTemplate
]
