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
PvSystemEnvironment >> allBehaviors [

	^ self class environment allBehaviors
]

{ #category : 'query' }
PvSystemEnvironment >> allClassesAndTraits [

	^ self class environment allClassesAndTraits
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
	
	^ self organizer packages
]
