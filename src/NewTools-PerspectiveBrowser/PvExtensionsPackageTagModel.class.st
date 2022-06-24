Class {
	#name : #PvExtensionsPackageTagModel,
	#superclass : #PvVirtualPackageTagModel,
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #accessing }
PvExtensionsPackageTagModel >> classes [

	^ self package extendedClasses 
		collect: [ :each | 
			StExtendedClassModel 
				newClass: each 
				package: self package ]
]

{ #category : #accessing }
PvExtensionsPackageTagModel >> colorName [

	^ #cyan
]

{ #category : #accessing }
PvExtensionsPackageTagModel >> name [

	^ 'Extensions'
]
