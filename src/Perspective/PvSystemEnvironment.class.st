Class {
	#name : 'PvSystemEnvironment',
	#superclass : 'PvEnvironment',
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvSystemEnvironment >> addPackageNamed: aName [

	self organizer addPackage: (Package named: aName)
]

{ #category : 'query' }
PvSystemEnvironment >> allBaselines [

	^ BaselineOf allSubclasses
]

{ #category : 'query' }
PvSystemEnvironment >> allBehaviors [

	^ self class environment allBehaviors
]

{ #category : 'query' }
PvSystemEnvironment >> allClassesAndTraits [

	^ self class environment allClassesAndTraits
]

{ #category : 'query' }
PvSystemEnvironment >> allPackages [

	^ self organizer packages
]

{ #category : 'accessing' }
PvSystemEnvironment >> classNamed: aName [

	^ Smalltalk classNamed: aName
]

{ #category : 'testing' }
PvSystemEnvironment >> hasPackageNamed: aString [

	^ self organizer hasPackage:  aString
]

{ #category : 'accessing' }
PvSystemEnvironment >> name [

	^ 'System Environment'
]

{ #category : 'private' }
PvSystemEnvironment >> organizer [

	^  PackageOrganizer default
]

{ #category : 'accessing' }
PvSystemEnvironment >> packageNamed: aString [

	^ self organizer packageNamed: aString
]

{ #category : 'accessing' }
PvSystemEnvironment >> packages [
	
	self 
		deprecated: 'We use #allPackages for consistency' 
		transformWith: '`@receiver packages' -> '`@receiver allPackages'.
	
	^ self allPackages
]

{ #category : 'accessing' }
PvSystemEnvironment >> removePackageNamed: aName [

	self organizer removePackage: (self packageNamed: aName)
]
