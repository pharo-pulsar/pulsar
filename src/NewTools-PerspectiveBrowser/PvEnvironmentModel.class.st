Class {
	#name : #PvEnvironmentModel,
	#superclass : #PvEntityModel,
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #accessing }
PvEnvironmentModel >> children [

	^ (self entity packages 
		collect: [ :each | PvPackageModel newEntity: each ])
		sorted: #name ascending
]

{ #category : #testing }
PvEnvironmentModel >> hasPackageNamed: aString [ 
	
	^ self entity hasPackageNamed: aString
]

{ #category : #accessing }
PvEnvironmentModel >> name [

	^ self entity name
]

{ #category : #accessing }
PvEnvironmentModel >> packageModelNamed: aString [ 
	
	^ PvPackageModel newEntity: (self entity packageNamed: aString)
]
