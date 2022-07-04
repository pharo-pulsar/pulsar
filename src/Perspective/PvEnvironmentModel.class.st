Class {
	#name : #PvEnvironmentModel,
	#superclass : #PvEntityModel,
	#category : #'Perspective-Model'
}

{ #category : #'instance creation' }
PvEnvironmentModel class >> newEntity: anEnvironment [

	"I am a model for an environment, so I do not belong (at least for now) to 
	 an environment myself"
	^ self newEnvironment: nil entity: anEnvironment
]

{ #category : #accessing }
PvEnvironmentModel >> children [

	^ (self entity packages 
		collect: [ :each | PvPackageModel newEnvironment: self entity: each ])
		sorted: #name ascending
]

{ #category : #testing }
PvEnvironmentModel >> hasPackageNamed: aString [ 
	
	^ self entity hasPackageNamed: aString
]

{ #category : #accessing }
PvEnvironmentModel >> iconName [

	^ 'library'
]

{ #category : #accessing }
PvEnvironmentModel >> name [

	^ self entity name
]

{ #category : #accessing }
PvEnvironmentModel >> packageModelNamed: aString [ 
	
	^ PvPackageModel 
		newEnvironment: self 
		entity: (self entity packageNamed: aString)
]
