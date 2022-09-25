Class {
	#name : #PvCommandGroup,
	#superclass : #CmCommandGroup,
	#instVars : [
		'priority',
		'id'
	],
	#category : #'Perspective-Command'
}

{ #category : #accessing }
PvCommandGroup class >> defaultPriority [

	^ 100
]

{ #category : #converting }
PvCommandGroup >> asSpecGroup [

	^ self decorateWith: PvSpecCommandGroup
]

{ #category : #accessing }
PvCommandGroup >> id [

	^ id
]

{ #category : #accessing }
PvCommandGroup >> id: anObject [

	id := anObject
]

{ #category : #accessing }
PvCommandGroup >> priority [

	^ priority ifNil: [ self class defaultPriority ]
]

{ #category : #accessing }
PvCommandGroup >> priority: anObject [

	priority := anObject
]
