Class {
	#name : #StBaseClassModel,
	#superclass : #Object,
	#instVars : [
		'modelClass'
	],
	#category : #'NewTools-Browser-Model'
}

{ #category : #'instance creation' }
StBaseClassModel class >> newClass: aClass [

	^ self new 
		modelClass: aClass;
		yourself
]

{ #category : #'accessing - parallel hierarchy' }
StBaseClassModel >> classSide [

	^ self subclassResponsibility
]

{ #category : #accessing }
StBaseClassModel >> icon [
	
	^ nil
]

{ #category : #testing }
StBaseClassModel >> inheritsFrom: aClassModel [ 
	
	aClassModel ifNil: [ ^ false ].
	^ self modelClass instanceSide inheritsFrom: aClassModel modelClass instanceSide
]

{ #category : #'accessing - parallel hierarchy' }
StBaseClassModel >> instanceSide [

	^ self subclassResponsibility
]

{ #category : #accessing }
StBaseClassModel >> modelClass [

	^ modelClass
]

{ #category : #accessing }
StBaseClassModel >> modelClass: aClass [

	modelClass := aClass
]

{ #category : #accessing }
StBaseClassModel >> name [

	self subclassResponsibility
]

{ #category : #accessing }
StBaseClassModel >> newProtocolModelFor: aProtocol [

	^ StProtocolModel newClass: self modelClass protocol: aProtocol
]

{ #category : #accessing }
StBaseClassModel >> protocols [

	^ (self modelClass organization allProtocols 
		collect: [ :each | self newProtocolModelFor: each ])
		sorted: #order ascending, #name ascending
]
