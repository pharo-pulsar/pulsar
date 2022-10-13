Class {
	#name : #PvMethodEditorProtocolChanged,
	#superclass : #Announcement,
	#instVars : [
		'newProtocol',
		'oldProtocol'
	],
	#category : #'Perspective-Method-View'
}

{ #category : #accessing }
PvMethodEditorProtocolChanged >> newProtocol [

	^ newProtocol
]

{ #category : #accessing }
PvMethodEditorProtocolChanged >> newProtocol: anObject [

	newProtocol := anObject
]

{ #category : #accessing }
PvMethodEditorProtocolChanged >> oldProtocol [

	^ oldProtocol
]

{ #category : #accessing }
PvMethodEditorProtocolChanged >> oldProtocol: anObject [

	oldProtocol := anObject
]
