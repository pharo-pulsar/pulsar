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
PvExtensionsPackageTagModel >> children [

	^ self classes
]

{ #category : #accessing }
PvExtensionsPackageTagModel >> classes [

	^ self entity extendedClasses 
		collect: [ :each | 
			PvExtendedClassModel 
				newEnvironment: self environmentModel 
				entity: each ]
]

{ #category : #accessing }
PvExtensionsPackageTagModel >> iconName [

	^ 'groupByMethod'
]

{ #category : #accessing }
PvExtensionsPackageTagModel >> name [

	^ 'Extensions'
]
