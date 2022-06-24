Class {
	#name : #PvSystemEnvironment,
	#superclass : #PvEnvironment,
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #testing }
PvSystemEnvironment >> hasPackageNamed: aString [

	^ self organizer includesPackageNamed: aString
]

{ #category : #accessing }
PvSystemEnvironment >> name [

	^ 'System'
]

{ #category : #private }
PvSystemEnvironment >> organizer [

	^  RPackageOrganizer default
]

{ #category : #accessing }
PvSystemEnvironment >> packageNamed: aString [

	^ self organizer packageNamed: aString
]

{ #category : #accessing }
PvSystemEnvironment >> packages [
	
	^ self organizer packages
]
