Class {
	#name : #PvNewClass,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : #'Perspective-Class-Model'
}

{ #category : #'instance creation' }
PvNewClass class >> newParent: aPackageOrTag [

	^ self new
		parent: aPackageOrTag;
		yourself
]

{ #category : #helpers }
PvNewClass >> classDefinitionString [

	^ self parent classDefinitionString
]

{ #category : #accessing }
PvNewClass >> name [
	
	^ 'New class'
]

{ #category : #accessing }
PvNewClass >> parent [

	^ parent
]

{ #category : #accessing }
PvNewClass >> parent: aPackageOrTag [

	parent := aPackageOrTag
]
