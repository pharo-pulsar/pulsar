Class {
	#name : #PvExtensionsPackageTagModel,
	#superclass : #PvVirtualPackageTagModel,
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #accessing }
PvExtensionsPackageTagModel class >> order [

	^ 1000
]

{ #category : #accessing }
PvExtensionsPackageTagModel >> classes [

	^ self package extendedClasses 
		collect: [ :each | 
			StExtendedClassModel 
				newClass: each 
				package: self package ]
]

{ #category : #accessing }
PvExtensionsPackageTagModel >> name [

	^ 'Extensions'
]
