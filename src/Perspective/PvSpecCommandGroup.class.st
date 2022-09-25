Class {
	#name : #PvSpecCommandGroup,
	#superclass : #SpCommandGroup,
	#category : #'Perspective-Command'
}

{ #category : #accessing }
PvSpecCommandGroup >> id [

	^ self decoratedGroup id
]

{ #category : #accessing }
PvSpecCommandGroup >> id: aSymbol [

	self decoratedGroup id: aSymbol
]

{ #category : #accessing }
PvSpecCommandGroup >> priority [

	^ self decoratedGroup priority
]

{ #category : #accessing }
PvSpecCommandGroup >> priority: aNumber [

	self decoratedGroup priority: aNumber
]
