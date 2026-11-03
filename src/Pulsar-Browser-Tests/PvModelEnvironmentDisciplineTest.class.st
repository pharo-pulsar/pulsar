Class {
	#name : 'PvModelEnvironmentDisciplineTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'support' }
PvModelEnvironmentDisciplineTest >> allowedMethodsByClass [

	"Methods where a local-only message is intentional (capabilities:
	 compilation, AST, execution, Metacello, Iceberg)."
	^ Dictionary new
		at: #PvClassModel put: #(runTestAnnouncingTo:);
		at: #PvMethodModel put: #(ffiCallArrayNode formattedSourceCode installIconStylerOn: runScript);
		at: #PvSlotModel put: #(slotName);
		at: #PulsarProjectModel put: #(dependencyModels collectDependencyModels dependencesEnvironment packagesOn: collectPackageModelsOn:);
		at: #PulsarTestCase put: #(asEntityModel);
		at: #PulsarVersionsModel put: #(fetchRemoteVersionsOn: ringDefinition);
		yourself
]

{ #category : 'support' }
PvModelEnvironmentDisciplineTest >> allowedSelectorsByClass [

	"Messages that are legitimately sent to environment tokens.
	 #= and #hash are token identity; #ifNil: and #printString are Object protocol.
	 #selector and #class are accepted only for runtime objects (test cases, Iceberg entities)
	 that are not part of the Pharo metamodel."
	^ Dictionary new
		at: #PulsarBaseTestModel put: #(#= #hash);
		at: #PulsarMultiProjectModel put: #(#=);
		at: #PulsarVolatileProjectModel put: #(#=);
		at: #PulsarProjectModel put: #(#ifNil: #project);
		at: #PulsarTestCase put: #(#class #selector #= #hash);
		at: #PulsarTestRunnerModel put: #(#= #selector);
		at: #PulsarVersionsModel put: #(#log);
		yourself
]

{ #category : 'support' }
PvModelEnvironmentDisciplineTest >> isEntityReceiver: aNode [

	aNode ifNil: [ ^ false ].
	^ (aNode isVariable and: [ aNode name = 'entity' ])
		or: [ (aNode isKindOf: OCMessageNode) and: [ aNode selector = #entity ] ]
]

{ #category : 'support' }
PvModelEnvironmentDisciplineTest >> localOnlySelectors [

	"Selectors that require a live object and must not be sent to an entity
	 outside an explicit capability method."
	^ #(ast suite valueWithReceiver: asRingDefinition lookupSelector: new class
		log project className version workingCopy)
]

{ #category : 'support' }
PvModelEnvironmentDisciplineTest >> modelClasses [

	^ #(PvEnvironmentModel PvPackageModel PvPackageTagModel
		PvExtensionsPackageTagModel PvUncategorizedPackageTagModel
		PvClassModel PvOutlineClassModel PvClassHierarchyNodeModel
		PvMethodModel PvMethodHierarchyNodeModel PvProtocolModel
		PvSlotModel PvSharedVaribleModel
		PulsarProjectModel PulsarMultiProjectModel PulsarVolatileProjectModel
		PulsarBaseTestModel PulsarTestCase PulsarTestSuite
		PulsarTestRunnerModel PulsarVersionsModel)
		collect: [ :each | Smalltalk globals at: each ]
]

{ #category : 'tests' }
PvModelEnvironmentDisciplineTest >> testModelsOnlyUseLocalCapabilitiesExplicitly [

	| violations |
	violations := OrderedCollection new.
	self modelClasses do: [ :cls |
		| allowed |
		allowed := self allowedMethodsByClass at: cls name ifAbsent: [ #() ].
		cls selectors do: [ :sel |
			(allowed includes: sel) ifFalse: [
				| ast |
				ast := (cls methodDictionary at: sel) ast.
				ast ifNotNil: [
					ast nodesDo: [ :node |
						((node isKindOf: OCMessageNode)
							and: [ self isEntityReceiver: node receiver ])
							ifTrue: [
								(self localOnlySelectors includes: node selector) ifTrue: [
									violations add: cls name , '>>' , sel , ' sends #' , node selector ] ] ] ] ] ] ].
	self assert: violations isEmpty description: (violations joinUsing: ', ')
]
