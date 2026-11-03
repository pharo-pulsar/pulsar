"
I am the environment facade over the local Pharo image.

Entity tokens are live Pharo objects (Class, Trait, CompiledMethod, RPackage, RPackageTag, Protocol, Slot). I answer all metamodel queries locally and I implement the write operations directly on the image.
"
Class {
	#name : 'PulsarSystemEnvironment',
	#superclass : 'PulsarEnvironment',
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'environment' }
PulsarSystemEnvironment >> addPackageNamed: aName [

	self organizer addPackage: (Package named: aName)
]

{ #category : 'environment' }
PulsarSystemEnvironment >> allBaselines [

	^ BaselineOf allSubclasses
]

{ #category : 'environment' }
PulsarSystemEnvironment >> allBehaviors [

	^ self class environment allBehaviors
]

{ #category : 'environment' }
PulsarSystemEnvironment >> allClassesAndTraits [

	^ self class environment allClassesAndTraits
]

{ #category : 'environment' }
PulsarSystemEnvironment >> allImplementorsOf: aSelector [

	^ SystemNavigation default allImplementorsOf: aSelector
]

{ #category : 'environment' }
PulsarSystemEnvironment >> allPackages [

	^ self organizer packages
]

{ #category : 'capabilities' }
PulsarSystemEnvironment >> asRBNamespace [

	^ RBBrowserEnvironment new
]

{ #category : 'capabilities' }
PulsarSystemEnvironment >> astOfMethod: aMethod [

	^ aMethod ast
]

{ #category : 'environment' }
PulsarSystemEnvironment >> classNamed: aName [

	^ Smalltalk classNamed: aName
]

{ #category : 'capabilities' }
PulsarSystemEnvironment >> compilerForClass: aClass [

	^ aClass compilerClass new
]

{ #category : 'capabilities' }
PulsarSystemEnvironment >> definitionStringOf: aClass [

	^ aClass isClassOrTrait
		  ifTrue: [ (PvFluidClassDefinitionPrinter for: aClass) definitionString ]
		  ifFalse: [ aClass classDefinitionString ]
]

{ #category : 'environment' }
PulsarSystemEnvironment >> hasPackageNamed: aString [

	^ self organizer hasPackage: aString
]

{ #category : 'testing' }
PulsarSystemEnvironment >> isLocal [

	^ true
]

{ #category : 'capabilities' }
PulsarSystemEnvironment >> localClassOf: aClass [

	^ aClass
]

{ #category : 'capabilities' }
PulsarSystemEnvironment >> localMethodOf: aMethod [

	^ aMethod
]

{ #category : 'accessing' }
PulsarSystemEnvironment >> name [

	^ 'System Environment'
]

{ #category : 'environment' }
PulsarSystemEnvironment >> organizer [

	^ PackageOrganizer default
]

{ #category : 'environment' }
PulsarSystemEnvironment >> packageNamed: aString [

	^ self organizer packageNamed: aString
]

{ #category : 'environment' }
PulsarSystemEnvironment >> packagesOfBaseline: aBaselineClass [

	^ aBaselineClass new project version packages
]

{ #category : 'environment' }
PulsarSystemEnvironment >> projectSpecsOfBaseline: aBaselineClass [

	^ aBaselineClass new project version projects
]

{ #category : 'capabilities' }
PulsarSystemEnvironment >> rbEnvironmentOfPackages: aCollection [

	| environment |
	environment := SystemEnvironment new.
	aCollection do: [ :eachPackage |
		eachPackage definedClasses do: [ :eachClass |
			environment at: eachClass name put: eachClass ] ].
	^ environment
]

{ #category : 'environment' }
PulsarSystemEnvironment >> removePackageNamed: aName [

	self organizer removePackage: (self packageNamed: aName)
]

{ #category : 'testing' }
PulsarSystemEnvironment >> supportsAst [

	^ true
]

{ #category : 'testing' }
PulsarSystemEnvironment >> supportsCompilation [

	^ true
]

{ #category : 'capabilities' }
PulsarSystemEnvironment >> systemDictionary [

	^ self class environment
]

{ #category : 'capabilities' }
PulsarSystemEnvironment >> valueOfMethod: aMethod withReceiver: aReceiver [

	^ aMethod valueWithReceiver: aReceiver
]
