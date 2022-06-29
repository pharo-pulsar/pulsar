Class {
	#name : #PvEntityModel,
	#superclass : #Object,
	#instVars : [
		'entity'
	],
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #'instance creation' }
PvEntityModel class >> newEntity: anObject [

	^ self basicNew 
		entity: anObject;
		initialize;
		yourself
]

{ #category : #comparing }
PvEntityModel >> = other [

	^ self species = other species 
		and: [ self entity = other entity ]
]

{ #category : #visiting }
PvEntityModel >> accept: aVisitor [

]

{ #category : #accessing }
PvEntityModel >> children [
	
	^ #()
]

{ #category : #accessing }
PvEntityModel >> colorName [
	
	^ nil
]

{ #category : #accessing }
PvEntityModel >> entity [

	^ entity
]

{ #category : #accessing }
PvEntityModel >> entity: anObject [

	entity := anObject
]

{ #category : #comparing }
PvEntityModel >> hash [

	^ self species hash  
		bitXor: self entity hash
]

{ #category : #accessing }
PvEntityModel >> iconName [

	^ nil
]

{ #category : #accessing }
PvEntityModel >> name [

	^ self subclassResponsibility
]

{ #category : #accessing }
PvEntityModel >> pageTitle [

	^ self shortName
]

{ #category : #accessing }
PvEntityModel >> shortName [

	^ self name
]

{ #category : #accessing }
PvEntityModel >> windowIconName [

	^ self iconName
]

{ #category : #accessing }
PvEntityModel >> windowTitle [

	^ self name
]
