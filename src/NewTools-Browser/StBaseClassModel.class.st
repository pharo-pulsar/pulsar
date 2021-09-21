Class {
	#name : #StBaseClassModel,
	#superclass : #StBaseModel,
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

{ #category : #accessing }
StBaseClassModel class >> shortSize [
	
	^ 30
]

{ #category : #comparing }
StBaseClassModel >> = other [

	^ self species = other species 
		and: [ self modelClass = other modelClass ]
]

{ #category : #accessing }
StBaseClassModel >> classDepth [
	
	^ self modelClass classDepth
]

{ #category : #'accessing - parallel hierarchy' }
StBaseClassModel >> classSide [

	^ self subclassResponsibility
]

{ #category : #comparing }
StBaseClassModel >> hash [

	^ self species hash  
		bitXor: self modelClass hash
]

{ #category : #accessing }
StBaseClassModel >> iconName [
	
	^ self modelClass systemIconName
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
