Class {
	#name : #StExtensionsPackageTagModel,
	#superclass : #StVirtualPackageTagModel,
	#category : #'NewTools-Browser-Model'
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
StExtensionsPackageTagModel >> name [

	^ 'Extensions'
]
