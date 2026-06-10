"
PulsarPackageDependencyModel holds and computes the dependency data for a given package.

It resolves both outgoing dependencies (packages this package depends on) and
incoming dependencies (packages that depend on this package). The direction
can be toggled between #outgoing and #incoming.

This is a computed view model — it does not wrap a domain entity.
"
Class {
	#name : 'PulsarPackageDependencyModel',
	#superclass : 'Object',
	#instVars : [
		'packageName',
		'direction',
		'relationGraph',
		'compositesByTarget',
		'dependencyData'
	],
	#category : 'Pulsar-Browser-Tool-Package-Dependencies',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Package-Dependencies'
}

{ #category : 'private' }
PulsarPackageDependencyModel >> buildData [

	direction = #outgoing
		ifTrue: [ self buildOutgoingData ]
		ifFalse: [ self buildIncomingData ]
]

{ #category : 'private' }
PulsarPackageDependencyModel >> buildIncomingData [

	| checker report dependantNames |
	checker := StDependencyChecker new
		           shouldComputeMessageSendDependencies: false;
		           yourself.
	report := checker computeImageDependencies.
	dependantNames := report knownDependantsOf: packageName.

	dependencyData := dependantNames collect: [ :eachName |
		(relationGraph packageAt: eachName) 
			ifNil: [ StPackage onPackageNamed: eachName ] ]
]

{ #category : 'private' }
PulsarPackageDependencyModel >> buildOutgoingData [

	| analyzedPkg |
	analyzedPkg := relationGraph packageAt: packageName.
	analyzedPkg ifNil: [
			dependencyData := #(  ).
			compositesByTarget := Dictionary new.
			^ self ].

	compositesByTarget := analyzedPkg dependencies groupedBy: [ :each | each target ] having: [ :each | true ].

	dependencyData := compositesByTarget keys asSortedCollection: [ :a :b | a packageName < b packageName ]
]

{ #category : 'accessing' }
PulsarPackageDependencyModel >> compositesByTarget [

	^ compositesByTarget
]

{ #category : 'accessing' }
PulsarPackageDependencyModel >> dependencyData [

	^ dependencyData
]

{ #category : 'accessing' }
PulsarPackageDependencyModel >> dependencyItemsFor: aTargetPackage [

	| items |
	items := OrderedCollection new.
	(compositesByTarget at: aTargetPackage ifAbsent: [ #(  ) ]) do: [ :eachComposite |
		eachComposite dependencies do: [ :eachDep | items add: eachDep ] ].
	^ items
]

{ #category : 'accessing' }
PulsarPackageDependencyModel >> direction [

	^ direction
]

{ #category : 'private' }
PulsarPackageDependencyModel >> incomingSummary [

	^ dependencyData size asString , ' package(s) depend on ' , packageName
]

{ #category : 'initialization' }
PulsarPackageDependencyModel >> initialize [

	super initialize.
	direction := #outgoing.
	dependencyData := OrderedCollection new.
	compositesByTarget := Dictionary new
]

{ #category : 'private' }
PulsarPackageDependencyModel >> outgoingSummary [

	| count totalItems |
	count := dependencyData size.
	totalItems := compositesByTarget values
		              inject: 0
		              into: [ :sum :comps | sum + (comps inject: 0 into: [ :innerSum :comp | innerSum + comp dependencies size ]) ].
	^ packageName , ' depends on ' , count asString , ' package(s) (' , totalItems asString , ' total dependencies)'
]

{ #category : 'accessing' }
PulsarPackageDependencyModel >> packageName [

	^ packageName
]

{ #category : 'accessing' }
PulsarPackageDependencyModel >> packageName: aString [

	packageName := aString.
	self resolveDependencies.
	self buildData
]

{ #category : 'private' }
PulsarPackageDependencyModel >> resolveDependencies [

	relationGraph := StPackageRelationGraph onPackagesNamed: { packageName }.
	relationGraph shouldComputeMessageSendDependencies: false.
	[ relationGraph build ]
		on: StPotentialOutDatedDependencyWarning
		do: [ :ex | ex resume ]
]

{ #category : 'accessing' }
PulsarPackageDependencyModel >> summaryLabel [

	direction = #outgoing
		ifTrue: [ ^ self outgoingSummary ]
		ifFalse: [ ^ self incomingSummary ]
]

{ #category : 'actions' }
PulsarPackageDependencyModel >> toggleDirection [

	direction := direction = #outgoing
		             ifTrue: [ #incoming ]
		             ifFalse: [ #outgoing ].
	self buildData
]
