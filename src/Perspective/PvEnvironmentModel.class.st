Class {
	#name : 'PvEnvironmentModel',
	#superclass : 'PvBaseModel',
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvEnvironmentModel class >> newEntity: anEnvironment [

	"I am a model for an environment, so I do not belong (at least for now) to 
	 an environment myself"
	^ self newEnvironment: nil entity: anEnvironment
]

{ #category : 'instance creation' }
PvEnvironmentModel class >> onSystem [

	^ self newEntity: PulsarSystemEnvironment new
]

{ #category : 'accessing' }
PvEnvironmentModel >> addPackageNamed: aString [

	^ self entity addPackageNamed: aString
]

{ #category : 'accessing' }
PvEnvironmentModel >> allBaselines [

	^ self entity allBaselines
]

{ #category : 'accessing' }
PvEnvironmentModel >> allBehaviors [

	^ self entity allBehaviors
]

{ #category : 'accessing' }
PvEnvironmentModel >> allClassesAndTraits [

	^ self entity allClassesAndTraits
]

{ #category : 'accessing' }
PvEnvironmentModel >> allPackages [

	^ self entity allPackages
]

{ #category : 'accessing' }
PvEnvironmentModel >> asRBNamespace [

	^ self entity asRBNamespace
]

{ #category : 'testing' }
PvEnvironmentModel >> canBeRemoved [

	^ false
]

{ #category : 'testing' }
PvEnvironmentModel >> canBeRenamed [

	^ false
]

{ #category : 'accessing' }
PvEnvironmentModel >> children [

	^ (self entity allPackages collect: [ :each |
		   PvPackageModel newEnvironment: self parent: nil entity: each ])
		  sorted: #name ascending
]

{ #category : 'accessing' }
PvEnvironmentModel >> classNamed: aName [

	^ self entity classNamed: aName
]

{ #category : 'accessing' }
PvEnvironmentModel >> classesMatching: aName [

	^ self entity classesMatching: aName
]

{ #category : 'accessing' }
PvEnvironmentModel >> compilerForClass: aClass [

	^ self environment compilerForClass: aClass
]

{ #category : 'accessing - navigating' }
PvEnvironmentModel >> environmentModel [
	"in this case, I am my own environment model"

	^ self
]

{ #category : 'accessing' }
PvEnvironmentModel >> hasPackageNamed: aString [

	^ self entity hasPackageNamed: aString
]

{ #category : 'accessing' }
PvEnvironmentModel >> iconName [

	^ 'systemEnvironment'
]

{ #category : 'accessing' }
PvEnvironmentModel >> name [

	^ self entity name
]

{ #category : 'factory' }
PvEnvironmentModel >> newMultiProjectModel [

	^ PulsarMultiProjectModel newEnvironment: self
]

{ #category : 'factory' }
PvEnvironmentModel >> newPackageModelFor: aName [

	^ PvPackageModel 
		newEnvironment: self
		entity: (self packageNamed: aName)
]

{ #category : 'accessing' }
PvEnvironmentModel >> packageNamed: aString [

	^ self entity packageNamed: aString
]

{ #category : 'accessing' }
PvEnvironmentModel >> removePackageNamed: aString [

	^ self entity removePackageNamed: aString
]
