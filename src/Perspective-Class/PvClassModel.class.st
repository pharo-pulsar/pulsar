Class {
	#name : #PvClassModel,
	#superclass : #PvEntityModel,
	#category : #'Perspective-Class-Model'
}

{ #category : #visiting }
PvClassModel >> accept: aVisitor [
	
	^ aVisitor visitClassModel: self
]

{ #category : #'accessing - announcement' }
PvClassModel >> activatedAnnouncementClass [
	
	^ PvClassActivatedAnnouncement
]

{ #category : #accessing }
PvClassModel >> classDefinition [

	^ self entity definitionString
]

{ #category : #accessing }
PvClassModel >> classDefinitionString [
	
	^ (FluidClassDefinitionPrinter for: self entity) definitionString
]

{ #category : #accessing }
PvClassModel >> classDepth [
	
	^ self entity classDepth
]

{ #category : #'accessing - parallel hierarchy' }
PvClassModel >> classSide [

	^ StMetaclassModel newClass: self entity classSide
]

{ #category : #accessing }
PvClassModel >> comment [

	^ self entity comment
]

{ #category : #accessing }
PvClassModel >> editorClass [
	
	^ PvClassEditorView
]

{ #category : #accessing }
PvClassModel >> iconName [
	
	^ self entity systemIconName
]

{ #category : #testing }
PvClassModel >> inheritsFrom: aClassModel [ 
	
	aClassModel ifNil: [ ^ false ].
	^ self entity instanceSide inheritsFrom: aClassModel entity instanceSide
]

{ #category : #accessing }
PvClassModel >> name [

	^ self entity name asString
]

{ #category : #'instance creation' }
PvClassModel >> newOutlineClassModel [

	^ PvOutlineClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : #'accessing - announcement' }
PvClassModel >> selectedAnnouncementClass [

	^ PvClassSelectedAnnouncement
]

{ #category : #accessing }
PvClassModel >> shortName [
	
	^ self name contractTo: self class shortSize
]

{ #category : #accessing }
PvClassModel >> windowCommentIconName [

	^ self entity hasComment
		ifTrue: [ #comments ]
		ifFalse: [ #uncommentedClass ]
]
