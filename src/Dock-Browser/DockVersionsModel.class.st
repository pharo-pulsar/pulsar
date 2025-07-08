Class {
	#name : 'DockVersionsModel',
	#superclass : 'PvBaseModel',
	#traits : 'DockTEditable',
	#classTraits : 'DockTEditable classTrait',
	#instVars : [
		'ringDefinition'
	],
	#category : 'Dock-Browser-Tool-Versions',
	#package : 'Dock-Browser',
	#tag : 'Tool-Versions'
}

{ #category : 'accessing' }
DockVersionsModel >> dockEditorClass [

	^ DockVersionsBrowser
]

{ #category : 'accessing' }
DockVersionsModel >> fullName [

	^ self name
]

{ #category : 'accessing - ui' }
DockVersionsModel >> iconName [

	^ #versions
]

{ #category : 'accessing' }
DockVersionsModel >> name [

	^ 'History of ', self ringDefinition fullName
]

{ #category : 'as yet unclassified' }
DockVersionsModel >> revertTo: aRGMethodDefinition [
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
DockVersionsModel >> ringDefinition [

	^ ringDefinition ifNil: [ ringDefinition := self entity asRingDefinition ]
]

{ #category : 'accessing' }
DockVersionsModel >> title [

	^ self name
]

{ #category : 'accessing' }
DockVersionsModel >> versions [

	self ringDefinition sourcePointer ifNil:[ ^ #() ].
	^ (SourceFiles changeRecordsFor: self ringDefinition)
		collectWithIndex: [ :each :index | 
			| rgMethodDefinition |
			rgMethodDefinition := each asRingDefinition.
			rgMethodDefinition annotationNamed: #versionIndex put: index ]
]
