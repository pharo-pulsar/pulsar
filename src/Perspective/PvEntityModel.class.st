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

{ #category : #visiting }
PvEntityModel >> accept: aVisitor [

]

{ #category : #'accessing - announcement' }
PvEntityModel >> activatedAnnouncement [

	^ self activatedAnnouncementClass new 
		model: self;
		yourself
]

{ #category : #'accessing - announcement' }
PvEntityModel >> activatedAnnouncementClass [

	^ PvActivatedAnnouncement
]

{ #category : #accessing }
PvEntityModel >> children [
	
	^ #()
]

{ #category : #accessing }
PvEntityModel >> colorName [
	
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

{ #category : #accessing }
PvEntityModel >> iconComposite [

	^ PvCompositeIcon new 
		name: self iconName;
		yourself
]

{ #category : #accessing }
PvEntityModel >> iconName [

	^ nil
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

{ #category : #accessing }
PvEntityModel >> pageTitle [

	^ self shortName
]

{ #category : #'accessing - announcement' }
PvEntityModel >> selectedAnnouncement [

	^ self selectedAnnouncementClass new 
		model: self;
		yourself
]

{ #category : #'accessing - announcement' }
PvEntityModel >> selectedAnnouncementClass [

	^ PvSelectedAnnouncement
]

{ #category : #accessing }
PvEntityModel >> shortName [

	^ self name
]

{ #category : #accessing }
PvEntityModel >> windowIconComposite [

	^ PvCompositeIcon new 
		name: self windowIconName;
		yourself
]

{ #category : #accessing }
PvEntityModel >> windowIconName [

	^ self iconName
]

{ #category : #accessing }
PvEntityModel >> windowTitle [

	^ self name
]
