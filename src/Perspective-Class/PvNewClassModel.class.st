Class {
	#name : #PvNewClassModel,
	#superclass : #PvClassModel,
	#category : #'Perspective-Class-Model'
}

{ #category : #visiting }
PvNewClassModel >> accept: aVisitor [
]

{ #category : #'accessing - announcement' }
PvNewClassModel >> activatedAnnouncementClass [

	^ PvNewClassActivatedAnnouncement
]

{ #category : #accessing }
PvNewClassModel >> children [

	^ #()
]

{ #category : #helpers }
PvNewClassModel >> classDefinitionString [
	
	^ self entity classDefinitionString
]

{ #category : #accessing }
PvNewClassModel >> editorClass [

	^ PvClassEditorView
]

{ #category : #'accessing - announcement' }
PvNewClassModel >> selectedAnnouncementClass [

	^ PvNewClassSelectedAnnouncement
]
