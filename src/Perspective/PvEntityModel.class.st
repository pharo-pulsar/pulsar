Class {
	#name : #PvEntityModel,
	#superclass : #Object,
	#instVars : [
		'entity',
		'environmentModel'
	],
	#category : #'Perspective-Model'
}

{ #category : #'instance creation' }
PvEntityModel class >> newEnvironment: anEnvironmentModel entity: anObject [

	^ self basicNew 
		environmentModel: anEnvironmentModel;
		entity: anObject;
		initialize;
		yourself
]

{ #category : #accessing }
PvEntityModel class >> shortSize [

	^ 30
]

{ #category : #comparing }
PvEntityModel >> = other [

	^ self species = other species 
		and: [ self entity = other entity ]
]

{ #category : #accessing }
PvEntityModel >> children [
	
	^ #()
]

{ #category : #'accessing - ui' }
PvEntityModel >> colorName [
	
	^ nil
]

{ #category : #'accessing - ui' }
PvEntityModel >> cursorPostitionWhenOpenEditor [
	"answer where to position the cursor (an index) when opening an editor"

	^ nil
]

{ #category : #accessing }
PvEntityModel >> entity [

	^ entity
]

{ #category : #initialization }
PvEntityModel >> entity: anObject [

	entity := anObject
]

{ #category : #accessing }
PvEntityModel >> environmentModel [ 
	
	^ environmentModel
]

{ #category : #initialization }
PvEntityModel >> environmentModel: anEnvironmentModel [ 
	
	environmentModel := anEnvironmentModel
]

{ #category : #comparing }
PvEntityModel >> hash [

	^ self species hash  
		bitXor: self entity hash
]

{ #category : #'accessing - ui' }
PvEntityModel >> iconComposite [

	^ PvCompositeIcon new 
		name: self iconName;
		yourself
]

{ #category : #'accessing - ui' }
PvEntityModel >> iconName [

	^ nil
]

{ #category : #testing }
PvEntityModel >> includesClassModel [

	self flag: #TODO. "This has to be solved in a better way (a double dispatch or something like that)"
	^ false
]

{ #category : #testing }
PvEntityModel >> isOutlineClassEntity [

	^ false
]

{ #category : #testing }
PvEntityModel >> isPackage [

	^ false
]

{ #category : #testing }
PvEntityModel >> isPackageOrTag [

	^ self isPackage or: [ self isPackageTag ]
]

{ #category : #testing }
PvEntityModel >> isPackageTag [

	^ false
]

{ #category : #testing }
PvEntityModel >> matches: aPattern [

	^ self name asLowercase beginsWith: aPattern
]

{ #category : #accessing }
PvEntityModel >> name [

	^ self subclassResponsibility
]

{ #category : #'accessing - ui' }
PvEntityModel >> pageTitle [

	^ self shortName
]

{ #category : #'accessing - compatibility' }
PvEntityModel >> protocol [
	
	^ nil
]

{ #category : #accessing }
PvEntityModel >> shortName [

	^ self name
]

{ #category : #accessing }
PvEntityModel >> spotterTitle [

	^ self windowTitle
]

{ #category : #'accessing - ui' }
PvEntityModel >> windowIconComposite [

	^ PvCompositeIcon new 
		name: self windowIconName;
		yourself
]

{ #category : #'accessing - ui' }
PvEntityModel >> windowIconName [

	^ self iconName
]

{ #category : #'accessing - ui' }
PvEntityModel >> windowTitle [

	^ self name
]
