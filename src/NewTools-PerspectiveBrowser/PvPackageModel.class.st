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

{ #category : #comparing }
PvPackageModel >> = other [

	^ self species = other species 
		and: [ self entity = other entity ]
]

{ #category : #accessing }
PvPackageModel >> children [

	^ (((self entity classTags 
		reject: [ :each | each name = self name ]) 
		collect: [ :each | PvPackageTagModel newEntity: each ]
		as: OrderedCollection)
		sorted: #name ascending)
		addAll: (PvVirtualPackageTagModel newVirtualModelsFor: self entity);
		yourself
]

{ #category : #accessing }
PvPackageModel >> classes [

	^ self entity definedClasses
		collect: [ :each | PvClassModel newEntity: each ]
		as: OrderedCollection
]

{ #category : #comparing }
PvPackageModel >> hash [ 

	^ self species hash 
		bitXor: self entity hash
]

{ #category : #accessing }
PvPackageModel >> iconName [

	^ #package
	
]

{ #category : #accessing }
PvPackageModel >> name [

	^ self entity packageName
]
