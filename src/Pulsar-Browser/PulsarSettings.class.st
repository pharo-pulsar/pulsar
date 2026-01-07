"
A settings file to concentrate Pulsar settings.

Since this can be shared between images, the settings are stored in a ston file in pharo-local (but this may change in the future, to store them in ./config/pharo
"
Class {
	#name : 'PulsarSettings',
	#superclass : 'Object',
	#instVars : [
		'settings',
		'mutex'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'private' }
PulsarSettings class >> settingsFileName [

	^ 'dockbrowser.ston'
]

{ #category : 'private' }
PulsarSettings class >> settingsFileReference [

	^ FileLocator localDirectory / self settingsFileName
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

{ #category : 'accessing' }
PulsarSettings >> settingAt: aKey [

	^ self 
		settingAt: aKey 
		ifAbsent: [ nil ]
]

{ #category : 'accessing' }
PulsarSettings >> settingAt: aKey ifAbsent: aBlock [

	^ self settings 
		at: aKey 
		ifAbsent: aBlock
]

{ #category : 'accessing' }
PulsarSettings >> settingAt: aKey ifAbsentPut: aBlock [
	
	^ self settings 
		at: aKey 
		ifAbsent: [ 
			self settingAt: aKey put: aBlock ]
]

{ #category : 'accessing' }
PulsarSettings >> settingAt: aKey ifPresent: aBlock [

	^ self settings 
		at: aKey 
		ifPresent: aBlock
]

{ #category : 'accessing' }
PulsarSettings >> settingAt: aKey put: aValue [

	self settings 
		at: aKey
		put: aValue.
	
	self store.
	
	^ aValue
]

{ #category : 'accessing' }
PulsarSettings >> settings [

	^ settings ifNil: [ settings := self retrieveSettingsIfPresent ]
]

{ #category : 'private' }
PulsarSettings >> settingsFileReference [

	^ self class settingsFileReference
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
