Class {
	#name : #PvExtensionsPackageTagModel,
	#superclass : #PvVirtualPackageTagModel,
	#category : #'Perspective-Package-Model'
}

{ #category : #accessing }
PvExtensionsPackageTagModel class >> order [

	^ 1000
]

{ #category : #accessing }
PvExtensionsPackageTagModel >> classes [

	^ self entity extendedClasses 
		collect: [ :each | 
			StExtendedClassModel 
				newClass: each 
				package: self entity ]
]

{ #category : #accessing }
PvExtensionsPackageTagModel >> iconName [

	^ 'groupByMethod'
]

{ #category : #accessing }
PvExtensionsPackageTagModel >> name [

	^ 'Extensions'
]
