"
Unit tests for PulsarSettings.

Covers in-memory dictionary operations, grouped settings, feature flags, UI settings, and file persistence with isolated test files.""
"
Class {
	#name : 'PulsarSettingsTest',
	#superclass : 'TestCase',
	#instVars : [
		'settings'
	],
	#category : 'Pulsar-Browser-Tests-Application',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Application'
}

{ #category : 'running' }
PulsarSettingsTest >> setUp [

	super setUp.
	settings := PulsarSettings new.
	settings settingsFileReference: FileLocator imageDirectory / 'pulsar-settings-test.ston'
]

{ #category : 'running' }
PulsarSettingsTest >> tearDown [

	settings settingsFileReference ensureDelete.
	super tearDown
]

{ #category : 'tests' }
PulsarSettingsTest >> testAtIfAbsentFiresBlockWhenMissing [

	 self assert: (settings at: #nonexistentKey ifAbsent: [ #fallback ]) equals: #fallback
]

{ #category : 'tests' }
PulsarSettingsTest >> testAtPutAndAt [

	settings at: #testKey put: #testValue.
	self assert: (settings at: #testKey) equals: #testValue
]

{ #category : 'tests' }
PulsarSettingsTest >> testAtPutSkipsWriteIfSameValue [

	settings at: #testKey put: #firstValue.
	settings at: #testKey put: #firstValue.
	self assert: (settings at: #testKey) equals: #firstValue
]

{ #category : 'tests' }
PulsarSettingsTest >> testAtReturnsNilForMissingKey [

	self assert: (settings at: #nonexistent) isNil
]

{ #category : 'tests' }
PulsarSettingsTest >> testEnsureGroupCreatesMissingGroup [

	settings ensureGroup: #newGroup.
	self assert: (settings settings includesKey: #newGroup).
	self assert: (settings defaults includesKey: #newGroup)
]

{ #category : 'tests' }
PulsarSettingsTest >> testFeatureEnable [

	settings feature: #myFeature enable: true.
	self assert: (settings features at: #myFeature) equals: true
]

{ #category : 'tests' }
PulsarSettingsTest >> testFeatures [

	| result |
	result := settings features.
	self assert: result isNotNil.
	self assert: result isEmpty.
	self assert: (settings settings at: #features) identicalTo: result
]

{ #category : 'tests' }
PulsarSettingsTest >> testGroupAtAtIfAbsentFiresBlockWhenMissing [

	self assert: (settings groupAt: #myGroup at: #nonexistent ifAbsent: [ #fallback ]) equals: #fallback
]

{ #category : 'tests' }
PulsarSettingsTest >> testGroupAtAtIfAbsentReturnsDefault [

	self assert: (settings groupAt: #ui at: #theme ifAbsent: [ #fallback ]) equals: #system
]

{ #category : 'tests' }
PulsarSettingsTest >> testGroupAtAtPutAndGroupAtAt [

	settings groupAt: #myGroup at: #myKey put: #myValue.
	self assert: (settings groupAt: #myGroup at: #myKey) equals: #myValue
]

{ #category : 'tests' }
PulsarSettingsTest >> testGroupAtAtReturnsNilForMissingKey [

	self assert: (settings groupAt: #myGroup at: #nonexistent) isNil
]

{ #category : 'tests' }
PulsarSettingsTest >> testInitializeSetsDefaults [

	self assert: settings defaults isNotNil.
	self assert: (settings defaults at: #ui) isNotNil.
	self assert: ((settings defaults at: #ui) at: #theme) equals: #system
]

{ #category : 'tests' }
PulsarSettingsTest >> testIsFeatureEnabledDefaultsToTrue [

	self assert: (settings isFeatureEnabled: #unknownFeature) equals: true
]

{ #category : 'tests' }
PulsarSettingsTest >> testIsFeatureEnabledReadsSetting [

	settings feature: #someFeature enable: false.
	self assert: (settings isFeatureEnabled: #someFeature) equals: false
]

{ #category : 'tests' }
PulsarSettingsTest >> testMutexLazyInit [

	| result |
	result := settings instVarNamed: #mutex.
	self assert: result isNil.

	result := settings mutex.
	self assert: result isNotNil.
	self assert: (result isKindOf: Mutex)
]

{ #category : 'tests' }
PulsarSettingsTest >> testSettingsFileReference [

	| ref |
	ref := settings settingsFileReference.
	self assert: ref isNotNil.
	self assert: ref basename equals: 'pulsar-settings-test.ston'
]

{ #category : 'tests' }
PulsarSettingsTest >> testSettingsLazilyLoadedFromDisk [

	| result |
	result := settings instVarNamed: #settings.
	self assert: result isNil.

	result := settings settings.
	self assert: result isNotNil.
	self assert: result isEmpty
]

{ #category : 'tests' }
PulsarSettingsTest >> testStoreDoesNotCreateFileWhenSettingsEmpty [

	| ref |
	ref := settings settingsFileReference.
	settings store.
	self deny: ref exists
]

{ #category : 'tests' }
PulsarSettingsTest >> testStorePersistsToDisk [

	| ref |
	settings at: #persistKey put: #persistValue.
	ref := settings settingsFileReference.
	self assert: ref exists.
	self assert: (STON fromString: ref contents) isNotNil
]

{ #category : 'tests' }
PulsarSettingsTest >> testStoreUsesMutex [

	settings at: #mutexKey put: #mutexValue.
	settings store.
	self assert: settings settingsFileReference exists
]

{ #category : 'tests' }
PulsarSettingsTest >> testStyleSchemeForDark [

	settings styleSchemeDark: 'monokai-dark'.
	self assert: (settings styleSchemeFor: true) equals: 'monokai-dark'
]

{ #category : 'tests' }
PulsarSettingsTest >> testStyleSchemeForDefaultsFromDefinition [

	 self assert: (settings styleSchemeFor: true) equals: 'Adwaita-dark'.
	 self assert: (settings styleSchemeFor: false) equals: 'Adwaita'
]

{ #category : 'tests' }
PulsarSettingsTest >> testStyleSchemeForLight [

	settings styleSchemeLight: 'monokai-light'.
	self assert: (settings styleSchemeFor: false) equals: 'monokai-light'
]

{ #category : 'tests' }
PulsarSettingsTest >> testSyntaxHighlightThemeForDark [

	settings syntaxHighlightThemeDark: 'solarized-dark'.
	self assert: (settings syntaxHighlightThemeFor: true) equals: 'solarized-dark'
]

{ #category : 'tests' }
PulsarSettingsTest >> testSyntaxHighlightThemeForDefaultsFromDefinition [

	self assert: (settiamp: '2026-06-01T17:09:19.502182+02:00' prior: 18588279
]

{ #category : 'tests' }
PulsarSettingsTest >> testSyntaxHighlightThemeForLight [

	settings syntaxHighlightThemeLight: 'solarized-light'.
	 self assert: (settings syntaxHighlightThemeFor: false) equals: 'solarized-light'
]

{ #category : 'tests' }
PulsarSettingsTest >> testTheme [

	self assert: settings theme equals: #system
]

{ #category : 'tests' }
PulsarSettingsTest >> testThemeStore [

	settings theme: #dark.
	self assert: settings theme equals: #dark
]

{ #category : 'tests' }
PulsarSettingsTest >> testUi [

	| result |
	result := settings ui.
	self assert: result isNotNil.
	self assert: result isEmpty.
	self assert: (settings settings at: #ui) identicalTo: result
]
