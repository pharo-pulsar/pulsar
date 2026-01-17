Class {
	#name : 'PulsarVersionsModel',
	#superclass : 'PvBaseModel',
	#traits : 'PulsarTEditable',
	#classTraits : 'PulsarTEditable classTrait',
	#instVars : [
		'ringDefinition'
	],
	#category : 'Pulsar-Browser-Tool-Versions',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Versions'
}

{ #category : 'accessing' }
PulsarVersionsModel >> fullName [

	^ self name
]

{ #category : 'accessing - ui' }
PulsarVersionsModel >> iconName [

	^ #versions
]

{ #category : 'accessing' }
PulsarVersionsModel >> name [

	^ 'History of ', self ringDefinition fullName
]

{ #category : 'accessing' }
PulsarVersionsModel >> pulsarEditorClass [

	^ PulsarVersionsBrowser
]

{ #category : 'as yet unclassified' }
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

	self ringDefinition sourcePointer ifNil:[ ^ #() ].
	^ (SourceFiles changeRecordsFor: self ringDefinition)
		collectWithIndex: [ :each :index | 
			| rgMethodDefinition |
			rgMethodDefinition := each asRingDefinition.
			rgMethodDefinition annotationNamed: #versionIndex put: index ]
]
