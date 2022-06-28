Class {
	#name : #PvVirtualPackageTagModel,
	#superclass : #PvEntityModel,
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #testing }
PvVirtualPackageTagModel class >> canBeUsedFor: aPackage [

	^ true
]

{ #category : #'instance creation' }
PvVirtualPackageTagModel class >> newVirtualModelsFor: aPackage [

	^ self allSubclasses 
		select: [ :each | each canBeUsedFor: aPackage ]
		thenCollect: [ :each | each newEntity: aPackage ]
]

{ #category : #accessing }
PvVirtualPackageTagModel class >> order [

	^ 100
]

{ #category : #comparing }
PvVirtualPackageTagModel >> = other [

	^ self species = other species
		and: [ self package = other package ] 
]

{ #category : #accessing }
PvVirtualPackageTagModel >> colorName [

	^ #cyan
]

{ #category : #comparing }
PvVirtualPackageTagModel >> hash [

	^ self species hash
		bitXor: self entity hash
]

{ #category : #testing }
PvVirtualPackageTagModel >> isRoot [

	^ false
]

{ #category : #accessing }
PvVirtualPackageTagModel >> order [

	^ self class order
]
