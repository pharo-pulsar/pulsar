Class {
	#name : #StExtensionsPackageTagModel,
	#superclass : #StVirtualPackageTagModel,
	#category : #'NewTools-Browser-Model-Package'
}

{ #category : #accessing }
StExtensionsPackageTagModel >> classes [

	^ self package extendedClasses 
		collect: [ :each | 
			StExtendedClassModel 
				newClass: each 
				package: self package ]
]

{ #category : #accessing }
StExtensionsPackageTagModel >> colorName [

	^ #cyan
]

{ #category : #accessing }
StExtensionsPackageTagModel >> name [

	^ 'Extensions'
]
