Class {
	#name : 'PvBaseModel',
	#superclass : 'Object',
	#instVars : [
		'entity',
		'environmentModel'
	],
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvBaseModel class >> newEnvironment: anEnvironmentModel entity: anObject [

	^ self basicNew 
		environmentModel: anEnvironmentModel;
		entity: anObject;
		initialize;
		yourself
]

{ #category : 'accessing' }
PvBaseModel class >> shortSize [

	^ 30
]

{ #category : 'comparing' }
PvBaseModel >> = other [

	^ self species = other species 
		and: [ self entity = other entity ]
]

{ #category : 'visiting' }
PvBaseModel >> accept: aVisitor [
	"to ensure specific process from models"
]

{ #category : 'accessing' }
PvBaseModel >> children [
	
	^ #()
]

{ #category : 'accessing - ui' }
PvBaseModel >> colorName [
	
	^ nil
]

{ #category : 'accessing - ui' }
PvBaseModel >> cursorPostitionWhenOpenEditor [
	"answer where to position the cursor (an index) when opening an editor"

	^ nil
]

{ #category : 'accessing - ui' }
PvBaseModel >> editorClass [

	^ nil
]

{ #category : 'accessing' }
PvBaseModel >> entity [

	^ entity
]

{ #category : 'initialization' }
PvBaseModel >> entity: anObject [

	entity := anObject
]

{ #category : 'accessing - navigating' }
PvBaseModel >> environmentModel [ 
	
	^ environmentModel
]

{ #category : 'initialization' }
PvBaseModel >> environmentModel: anEnvironmentModel [ 
	
	environmentModel := anEnvironmentModel
]

{ #category : 'testing' }
PvBaseModel >> hasEditor [

	^ self editorClass notNil
]

{ #category : 'comparing' }
PvBaseModel >> hash [

	^ self species hash  
		bitXor: self entity hash
]

{ #category : 'accessing - ui' }
PvBaseModel >> iconComposite [

	^ PvCompositeIcon new 
		name: self iconName;
		yourself
]

{ #category : 'accessing - ui' }
PvBaseModel >> iconName [

	^ nil
]

{ #category : 'testing' }
PvBaseModel >> includesClassModel [

	self flag: #TODO. "This has to be solved in a better way (a double dispatch or something like that)"
	^ false
]

{ #category : 'testing' }
PvBaseModel >> isOutlineClassEntity [

	^ false
]

{ #category : 'testing' }
PvBaseModel >> isPackage [

	^ false
]

{ #category : 'testing' }
PvBaseModel >> isPackageOrTag [

	^ self isPackage or: [ self isPackageTag ]
]

{ #category : 'testing' }
PvBaseModel >> isPackageTag [

	^ false
]

{ #category : 'testing' }
PvBaseModel >> isProject [

	^ false
]

{ #category : 'testing' }
PvBaseModel >> matches: aPattern [

	^ self name asLowercase beginsWith: aPattern asLowercase
]

{ #category : 'accessing' }
PvBaseModel >> name [

	^ self subclassResponsibility
]

{ #category : 'accessing - ui' }
PvBaseModel >> pageTitle [

	^ self shortName
]

{ #category : 'private' }
PvBaseModel >> prepareForSnapshot [
	"This is used when a model will be snapshot, to clean up what is not need/want to be kept "
]

{ #category : 'accessing - compatibility' }
PvBaseModel >> protocol [
	
	^ nil
]

{ #category : 'accessing' }
PvBaseModel >> shortName [

	^ self name
]

{ #category : 'accessing' }
PvBaseModel >> spotterTitle [

	^ self windowTitle
]

{ #category : 'accessing - ui' }
PvBaseModel >> windowIconComposite [

	^ PvCompositeIcon new 
		name: self windowIconName;
		yourself
]

{ #category : 'accessing - ui' }
PvBaseModel >> windowIconName [

	^ self iconName
]

{ #category : 'accessing - ui' }
PvBaseModel >> windowTitle [

	^ self name
]
