"
I am the abstract environment facade used by the Pulsar model layer.

Every metamodel query performed by a Pulsar model must go through an instance of one of my subclasses. Models receive *entity tokens* from me: they may compare them (#= / #hash) and print them, but they must never send metamodel messages to them.

Concrete implementations:
- PulsarSystemEnvironment - the local Pharo image; entity tokens are live Pharo objects.
- PulsarRemoteEnvironment - a remote Pharo image; entity tokens are proxies.

See PulsarEnvironment>>nameOf: for the minimal token protocol and the class comments of my subclasses for their token contracts.
"
Class {
	#name : 'PulsarEnvironment',
	#superclass : 'Object',
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'environment' }
PulsarEnvironment >> addPackageNamed:aString [ 
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> allBaselines [
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> allBehaviors [
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> allClassesAndTraits [
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> allImplementorsOf:aSelector [ 
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> allPackages [
	^ self subclassResponsibility
]

{ #category : 'capabilities' }
PulsarEnvironment >> asRBNamespace [
	^ self subclassResponsibility
]

{ #category : 'capabilities' }
PulsarEnvironment >> astOfMethod:aMethod [ 
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> classNamed:aSymbol [ 
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> classesMatching: aString [

	^ self allClassesAndTraits select: [ :each |
		  each name includesSubstring: aString caseSensitive: false ]
]

{ #category : 'capabilities' }
PulsarEnvironment >> compilerForClass:aClass [ 
	^ self subclassResponsibility
]

{ #category : 'capabilities' }
PulsarEnvironment >> definitionStringOf:aClass [ 
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> hasPackageNamed:aString [ 
	^ self subclassResponsibility
]

{ #category : 'testing' }
PulsarEnvironment >> isLocal [

	^ false
]

{ #category : 'capabilities' }
PulsarEnvironment >> localClassOf:aClass [ 
	^ self subclassResponsibility
]

{ #category : 'capabilities' }
PulsarEnvironment >> localMethodOf:aMethod [ 
	^ self subclassResponsibility
]

{ #category : 'accessing' }
PulsarEnvironment >> name [
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> packageNamed:aString [ 
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> packagesOfBaseline: aBaselineClass [
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> projectSpecsOfBaseline: aBaselineClass [
	^ self subclassResponsibility
]

{ #category : 'capabilities' }
PulsarEnvironment >> rbEnvironmentOfPackages: aCollection [
	^ self subclassResponsibility
]

{ #category : 'environment' }
PulsarEnvironment >> removePackageNamed:aString [ 
	^ self subclassResponsibility
]

{ #category : 'testing' }
PulsarEnvironment >> supportsAst [

	^ false
]

{ #category : 'testing' }
PulsarEnvironment >> supportsCompilation [

	^ false
]

{ #category : 'capabilities' }
PulsarEnvironment >> systemDictionary [
	^ self subclassResponsibility
]

{ #category : 'capabilities' }
PulsarEnvironment >> valueOfMethod:aMethod withReceiver:aReceiver [ 
	^ self subclassResponsibility
]
