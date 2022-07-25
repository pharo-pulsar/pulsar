Class {
	#name : #PvClassModel,
	#superclass : #PvEntityModel,
	#instVars : [
		'isNew'
	],
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

{ #category : #visiting }
PvClassModel >> beForNewClass [

	isNew := true
]

{ #category : #accessing }
PvClassModel >> classDefinitionString [
	
	^ (PvFluidClassDefinitionPrinter for: self entity) definitionString
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

{ #category : #compiling }
PvClassModel >> compile: aString notifying: requestor [
	| resultClass |

 	[ 
		resultClass := self class compiler
			source: '(', aString, ') install';
			context: requestor doItContext;
			receiver: requestor doItReceiver;
			requestor: requestor;
			evaluate.
		resultClass isBehavior 
			ifTrue: [ self entity: resultClass ] ]
	on: OCUndeclaredVariableWarning
	do: [ :e | 
		"we are only interested in class definitions"
		e compilationContext noPattern ifFalse: [ e pass ] ]
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

{ #category : #visiting }
PvClassModel >> initialize [

	super initialize.
	isNew := false
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
