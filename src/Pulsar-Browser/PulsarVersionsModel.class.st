Class {
	#name : 'PulsarVersionsModel',
	#superclass : 'PvBaseModel',
	#traits : 'PulsarTEditable',
	#classTraits : 'PulsarTEditable classTrait',
	#instVars : [
		'ringDefinition',
		'remoteVersions'
	],
	#category : 'Pulsar-Browser-Tool-Versions',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Versions'
}

{ #category : 'accessing' }
PulsarVersionsModel >> fetchRemoteVersionsOn: aRepositoryModel [

	remoteVersions := (aRepositoryModel entity log historyOfMethod: self entity)
		collect: [ :each | each asRingDefinition ]
]

{ #category : 'accessing' }
PulsarVersionsModel >> fullName [

	^ self name
]

{ #category : 'testing' }
PulsarVersionsModel >> hasValidRemote [
	
	^ self includingRepositories 
		anySatisfy: [ :each | (each isMissing or: [ each isDetached ]) not ]
]

{ #category : 'accessing - ui' }
PulsarVersionsModel >> iconName [

	^ #versions
]

{ #category : 'accessing' }
PulsarVersionsModel >> includingRepositories [
	| repositories packageName |
	
	packageName := self entity package name.
	^ IceRepository repositories 
		select: [ :each | each includesPackageNamed: packageName ]
		thenCollect: [ :each | 
			PulsarRepositoryModel 
				newEnvironment: self environmentModel 
				entity: each ]
]

{ #category : 'accessing' }
PulsarVersionsModel >> localVersions [

	self ringDefinition sourcePointer ifNil:[ ^ #() ].
	
	^ (SourceFiles changeRecordsFor: self ringDefinition)
		collectWithIndex: [ :each :index | 
			| rgMethodDefinition |
			rgMethodDefinition := each asRingDefinition.
			rgMethodDefinition annotationNamed: #versionIndex put: index ]
]

{ #category : 'accessing' }
PulsarVersionsModel >> name [

	^ 'History of ', self ringDefinition fullName
]

{ #category : 'accessing' }
PulsarVersionsModel >> pulsarEditorClass [

	^ PulsarVersionsBrowser
]

{ #category : 'accessing' }
PulsarVersionsModel >> remoteVersions [

	^ remoteVersions ifNil: [ #() ]
]

{ #category : 'actions' }
PulsarVersionsModel >> revertTo: aRGMethodDefinition [
	| newSelector realClass |

	aRGMethodDefinition ifNil: [ ^ self ].
	
	realClass := self ringDefinition realClass.
	newSelector := realClass
		compile: aRGMethodDefinition sourceCode
		classified: aRGMethodDefinition category
		withStamp: aRGMethodDefinition stamp
		notifying: nil.
		
	"update entity"
	self entity: realClass >> newSelector
]

{ #category : 'accessing' }
PulsarVersionsModel >> ringDefinition [

	^ ringDefinition ifNil: [ ringDefinition := self entity asRingDefinition ]
]

{ #category : 'accessing' }
PulsarVersionsModel >> title [

	^ self name
]

{ #category : 'accessing' }
PulsarVersionsModel >> versions [

	^ self localVersions, self remoteVersions
]
