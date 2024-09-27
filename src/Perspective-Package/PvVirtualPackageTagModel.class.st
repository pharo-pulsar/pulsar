Class {
	#name : 'PvVirtualPackageTagModel',
	#superclass : 'PvEntityModel',
	#category : 'Perspective-Package-Model',
	#package : 'Perspective-Package',
	#tag : 'Model'
}

{ #category : 'testing' }
PvVirtualPackageTagModel class >> canBeUsedFor: aPackage [

	^ true
]

{ #category : 'accessing' }
PvVirtualPackageTagModel class >> order [

	^ 100
]

{ #category : 'instance creation' }
PvVirtualPackageTagModel class >> virtualModelsFor: aPackage [

	^ self allSubclasses select: [ :each | each canBeUsedFor: aPackage ]

]

{ #category : 'accessing - ui' }
PvVirtualPackageTagModel >> colorName [

	^ #cyan
]

{ #category : 'testing' }
PvVirtualPackageTagModel >> isRoot [

	^ false
]

{ #category : 'accessing' }
PvVirtualPackageTagModel >> order [

	^ self class order
]
