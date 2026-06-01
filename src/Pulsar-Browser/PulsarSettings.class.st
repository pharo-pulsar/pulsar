"
A settings file to concentrate Pulsar settings.

Since this can be shared between images, the settings are stored in a ston file in pharo-local (but this may change in the future, to store them in ./config/pharo
"
Class {
	#name : 'PulsarSettings',
	#superclass : 'Object',
	#instVars : [
		'settings',
		'mutex',
		'defaults',
		'settingsFileReference'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'private - defaults' }
PulsarSettings class >> defaultSettings [

	^ STON fromString: self defaultSettingsDefinition
]

{ #category : 'defaults' }
PulsarSettings class >> defaultSettingsDefinition [

	  ^ '{
	#ui: { 
		#theme: #system,
		#styleSchemeLight: "Adwaita",
		#styleSchemeDark: "Adwaita-dark",
		#syntaxHighlightThemeLight: "CodeLight",
		#syntaxHighlightThemeDark: "CodeDark"
	},
	#features : {
		#experimental: false,
		#llm: false
	}
}
'
]

{ #category : 'private' }
PulsarSettings class >> settingsFileName [

	^ 'pulsar-settings.ston'
]

{ #category : 'accessing' }
PulsarSettings class >> settingsFileReference [

	^ FileLocator localDirectory / self settingsFileName
]

{ #category : 'private - accessing' }
PulsarSettings >> at: aKey [

	^ self at: aKey ifAbsent: [ nil ]
]

{ #category : 'private - accessing' }
PulsarSettings >> at: aKey ifAbsent: aBlock [

	^ self settings 
		at: aKey 
		ifAbsent: [ 
			self defaults 
				at: aKey 
				ifAbsent: aBlock ]
]

{ #category : 'private - accessing' }
PulsarSettings >> at: aKey put: aValue [
	"no need to re-write if already the same"
	(self at: aKey) = aValue ifTrue: [ ^ self ].

	self settings 
		at: aKey
		put: aValue.
	
	self store.
	
	^ aValue
]

{ #category : 'accessing' }
PulsarSettings >> defaults [

	^ defaults
]

{ #category : 'private - accessing' }
PulsarSettings >> ensureGroup: aSymbol [

	self settings 
		at: aSymbol
		ifAbsentPut: [ Dictionary new ].
		
	self defaults 
		at: aSymbol
		ifAbsentPut: [ Dictionary new ]
]

{ #category : 'accessing - features' }
PulsarSettings >> feature: aSymbol enable: aBoolean [
	"toggle enable/disable of a feature"

	^ self 
		groupAt: #features
		at: aSymbol
		put: aBoolean
]

{ #category : 'accessing - features' }
PulsarSettings >> features [

	^ self settings 
		at: #features
		ifAbsentPut: [ Dictionary new ]
]

{ #category : 'private - accessing' }
PulsarSettings >> groupAt: groupKey at: aKey [
	^ self 
		groupAt: groupKey 
		at: aKey 
		ifAbsent: [ nil ]
]

{ #category : 'private - accessing' }
PulsarSettings >> groupAt: groupKey at: aKey ifAbsent: aBlock [
	self ensureGroup: groupKey.

	^ self settings 
		at: groupKey
		at: aKey 
		ifAbsent: [ 
			self defaults 
				at: groupKey 
				at: aKey 
				ifAbsent: aBlock ]
]

{ #category : 'private - accessing' }
PulsarSettings >> groupAt: groupKey at: aKey put: aValue [

	"no need to re-write if already the same"
	(self groupAt: groupKey at: aKey) = aValue ifTrue: [ ^ self ].
	
	self ensureGroup: groupKey.

	self settings 
		at: groupKey
		at: aKey
		put: aValue.
	
	self store.
	
	^ aValue
]

{ #category : 'initialization' }
PulsarSettings >> initialize [

	super initialize.
	defaults := self class defaultSettings
]

{ #category : 'testing' }
PulsarSettings >> isFeatureEnabled: featureSymbol [
	"by default, features are enabled"
	
	^ self groupAt: #features at: featureSymbol ifAbsent: [ true ]
]

{ #category : 'private' }
PulsarSettings >> mutex [

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'private' }
PulsarSettings >> retrieveSettingsIfPresent [
	| fileReference |

	fileReference := self settingsFileReference.
	^ fileReference exists 
		ifTrue: [ STON fromString: fileReference contents ]
		ifFalse: [ Dictionary new ]
]

{ #category : 'private - accessing' }
PulsarSettings >> settings [

	^ settings ifNil: [ settings := self retrieveSettingsIfPresent ]
]

{ #category : 'private' }
PulsarSettings >> settingsFileReference [

	^ settingsFileReference ifNil: [ self class settingsFileReference ]
]

{ #category : 'private' }
PulsarSettings >> settingsFileReference: aFileReference [
	"used for testing"

	settingsFileReference := aFileReference
]

{ #category : 'private' }
PulsarSettings >> store [
	
	self mutex critical: [
		| fileReference |

		fileReference := self settingsFileReference.
		fileReference ensureDelete.
		
		settings isEmptyOrNil ifTrue: [ ^ self ].
		
		fileReference writeStreamDo: [ :stream |
			STON 
				put: settings 
				onStreamPretty: stream ] ]
]

{ #category : 'accessing - ui' }
PulsarSettings >> styleSchemeDark: aString [

	^ self groupAt: #ui at: #styleSchemeDark put: aString
]

{ #category : 'accessing - ui' }
PulsarSettings >> styleSchemeFor: isDarkTheme [

	^ self groupAt: #ui at: (isDarkTheme
		ifTrue: [ #styleSchemeDark ]
		ifFalse: [ #styleSchemeLight ])
]

{ #category : 'accessing - ui' }
PulsarSettings >> styleSchemeLight: aString [

	^ self groupAt: #ui at: #styleSchemeLight put: aString
]

{ #category : 'accessing - ui' }
PulsarSettings >> syntaxHighlightThemeDark: aString [

	^ self groupAt: #ui at: #syntaxHighlightThemeDark put: aString
]

{ #category : 'accessing - ui' }
PulsarSettings >> syntaxHighlightThemeFor: isDarkTheme [

	^ self groupAt: #ui at: (isDarkTheme
		ifTrue: [ #syntaxHighlightThemeDark ]
		ifFalse: [ #syntaxHighlightThemeLight ])
]

{ #category : 'accessing - ui' }
PulsarSettings >> syntaxHighlightThemeLight: aString [

	^ self groupAt: #ui at: #syntaxHighlightThemeLight put: aString
]

{ #category : 'accessing - ui' }
PulsarSettings >> theme [

	^ self groupAt: #ui at: #theme
]

{ #category : 'accessing - ui' }
PulsarSettings >> theme: aSymbol [

	self groupAt: #ui at: #theme put: aSymbol
]

{ #category : 'accessing - ui' }
PulsarSettings >> ui [

	^ self settings 
		at: #ui 
		ifAbsentPut: [ Dictionary new ]
]
