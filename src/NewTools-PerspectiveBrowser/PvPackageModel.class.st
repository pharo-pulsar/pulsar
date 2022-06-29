Class {
	#name : #PvPackageModel,
	#superclass : #PvEntityModel,
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #'instance creation' }
PvPackageModel class >> newPackage: aPackage [

	^ self new 
		package: aPackage;
		yourself
]

{ #category : #accessing }
PvPackageModel >> children [

	^ (((self entity classTags 
		reject: [ :each | each name = self name ]) 
		collect: [ :each | PvPackageTagModel newEntity: each ]
		as: OrderedCollection)
		addAll: (PvVirtualPackageTagModel newVirtualModelsFor: self entity);
		sorted: #order ascending, #name ascending)
		yourself
]

{ #category : #accessing }
PvPackageModel >> classes [

	^ self entity definedClasses
		collect: [ :each | PvClassModel newEntity: each ]
		as: OrderedCollection
]

{ #category : #accessing }
PvPackageModel >> iconName [

	^ #package
	
]

{ #category : #accessing }
PvPackageModel >> name [

	^ self entity packageName
]
