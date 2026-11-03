Class {
	#name : 'PulsarModelTestSuite',
	#superclass : 'Object',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'running' }
PulsarModelTestSuite class >> runAll [

	"Headless shared + system models. UI tests are run separately with #runUI."
	^ self runClasses: self sharedClasses, self systemModelsClasses
]

{ #category : 'running' }
PulsarModelTestSuite class >> runClasses: aCollection [

	| result |
	result := TestResult new.
	aCollection do: [ :each |
		| cls |
		cls := each isBehavior
			ifTrue: [ each ]
			ifFalse: [ Smalltalk globals at: each ifAbsent: [ nil ] ].
		cls ifNotNil: [ cls suite run: result ] ].
	^ result
]

{ #category : 'running' }
PulsarModelTestSuite class >> runShared [

	^ self runSharedWith: PulsarSystemEnvironment new
]

{ #category : 'running' }
PulsarModelTestSuite class >> runSharedWith: anEnvironment [

	^ PulsarModelTestEnvironment with: anEnvironment do: [ self runClasses: self sharedClasses ]
]

{ #category : 'running' }
PulsarModelTestSuite class >> runSystemModels [

	^ self runClasses: self systemModelsClasses
]

{ #category : 'running' }
PulsarModelTestSuite class >> runUI [

	^ self runClasses: self uiClasses
]

{ #category : 'classes' }
PulsarModelTestSuite class >> sharedClasses [

	"Headless model tests that must run against any PulsarEnvironment."
	^ #(PvBaseModelTest PvEnvironmentModelTest PvClassModelTest PvMethodModelTest
		PvPackageModelTest PvPackageTagModelTest PvProtocolModelTest PvSlotModelTest
		PvSharedVaribleModelTest PvTreeNodeModelTest PulsarProjectModelTest
		PulsarMultiProjectModelTest PulsarLoadedProjectTest PulsarEnvironmentContractTest)
]

{ #category : 'classes' }
PulsarModelTestSuite class >> systemModelsClasses [

	"Headless tests for models that only exist in the system/IDE environment."
	^ #(PulsarSystemEnvironmentContractTest PulsarEnvironmentCompletenessTest
		PvModelEnvironmentDisciplineTest PvEntityProtocolTest
		PulsarRepositoryBaseModelTest PulsarRepositoryModelTest
		PulsarRepositoryCommitModelTest PulsarRepositoriesModelTest
		PulsarVersionsModelTest PulsarMethodSourceModelTest
		PulsarFFIModelTest PulsarMethodTableModelTest PulsarContextModelTest)
]

{ #category : 'classes' }
PulsarModelTestSuite class >> uiClasses [

	"Headed UI/integration tests; they open Pulsar presenters and are not part of parity runs."
	^ #(PulsarClassEditorTest PulsarMethodEditorTest PulsarMessageBrowserTest
		PulsarProjectViewTest PulsarSingleProjectViewTest PulsarDirectoryBrowserTest
		PulsarSnapshotTest PulsarMillerColumnInspectorTest PulsarTranscriptTest
		PulsarDebuggerTest PulsarSettingsTest)
]
