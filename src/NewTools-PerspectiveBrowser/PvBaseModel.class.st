Class {
	#name : #PvBaseModel,
	#superclass : #Object,
	#instVars : [
		'entity'
	],
	#category : #'NewTools-PerspectiveBrowser-Model'
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
PvBaseModel >> associatedEditors [

	^ StBrowserAssociatedEditorSet new
]

{ #category : #accessing }
PvBaseModel >> children [
	
	^ #()
]

{ #category : #accessing }
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

{ #category : #accessing }
PvBaseModel >> iconName [

	^ nil
]

{ #category : #accessing }
PvBaseModel >> name [

	^ self subclassResponsibility
]

{ #category : #accessing }
PvBaseModel >> pageTitle [

	^ self shortName
]

{ #category : #accessing }
PvBaseModel >> shortName [

	^ self name
]

{ #category : #accessing }
PvBaseModel >> windowIconName [

	^ self iconName
]

{ #category : #accessing }
PvBaseModel >> windowTitle [

	^ self name
]
