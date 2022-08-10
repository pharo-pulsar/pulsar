Class {
	#name : #PvBaseModel,
	#superclass : #Object,
	#instVars : [
		'entity'
	],
	#category : #'Perspective-Model'
}

{ #category : #'instance creation' }
PvBaseModel class >> on: anObject [

	^ self basicNew 
		entity: anObject;
		initialize;
		yourself
]

{ #category : #visiting }
PvBaseModel >> accept: aVisitor [
	
]

{ #category : #accessing }
PvBaseModel >> children [
	
	^ #()
]

{ #category : #'accessing - ui' }
PvBaseModel >> colorName [
	
	^ nil
]

{ #category : #accessing }
PvBaseModel >> entity [

	^ entity
]

{ #category : #accessing }
PvBaseModel >> entity: anObject [

	entity := anObject
]

{ #category : #'accessing - ui' }
PvBaseModel >> iconName [

	^ nil
]

{ #category : #accessing }
PvBaseModel >> name [

	^ self subclassResponsibility
]

{ #category : #'accessing - ui' }
PvBaseModel >> pageTitle [

	^ self shortName
]

{ #category : #accessing }
PvBaseModel >> shortName [

	^ self name
]

{ #category : #'accessing - ui' }
PvBaseModel >> windowIconName [

	^ self iconName
]

{ #category : #'accessing - ui' }
PvBaseModel >> windowTitle [

	^ self name
]
