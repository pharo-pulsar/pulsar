Class {
	#name : #PvClassModel,
	#superclass : #PvEntityModel,
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #comparing }
PvClassModel >> = other [

	^ self species = other species 
		and: [ self entity = other entity ]
]

{ #category : #visiting }
PvClassModel >> accept: aVisitor [
	
	^ aVisitor visitClassModel: self
]

{ #category : #accessing }
PvClassModel >> classDefinition [

	^ self entity definitionString
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

{ #category : #comparing }
PvClassModel >> hash [

	^ self species hash  
		bitXor: self entity hash
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
