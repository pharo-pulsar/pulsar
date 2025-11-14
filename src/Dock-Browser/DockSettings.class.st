"
A settings file to concentrate Dock settings.

Since this can be shared between images, the settings are stored in a ston file in pharo-local (but this may change in the future, to store them in ./config/pharo
"
Class {
	#name : 'DockSettings',
	#superclass : 'Object',
	#instVars : [
		'settings',
		'mutex'
	],
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'private' }
DockSettings class >> settingsFileName [

	^ 'dockbrowser.ston'
]

{ #category : 'private' }
DockSettings class >> settingsFileReference [

	^ FileLocator localDirectory / self settingsFileName
]

{ #category : 'private' }
DockSettings >> mutex [

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'private' }
DockSettings >> retrieveSettingsIfPresent [
	| fileReference |

	fileReference := self settingsFileReference.
	^ fileReference exists 
		ifTrue: [ STON fromString: fileReference contents ]
		ifFalse: [ Dictionary new ]
]

{ #category : 'accessing' }
DockSettings >> settingAt: aKey [

	^ self 
		settingAt: aKey 
		ifAbsent: [ nil ]
]

{ #category : 'accessing' }
DockSettings >> settingAt: aKey ifAbsent: aBlock [

	^ self settings 
		at: aKey 
		ifAbsent: aBlock
]

{ #category : 'accessing' }
DockSettings >> settingAt: aKey ifAbsentPut: aBlock [
	
	^ self settings 
		at: aKey 
		ifAbsent: [ 
			self settingAt: aKey put: aBlock ]
]

{ #category : 'accessing' }
DockSettings >> settingAt: aKey ifPresent: aBlock [

	^ self settings 
		at: aKey 
		ifPresent: aBlock
]

{ #category : 'accessing' }
DockSettings >> settingAt: aKey put: aValue [

	self settings 
		at: aKey
		put: aValue.
	
	self store.
	
	^ aValue
]

{ #category : 'accessing' }
DockSettings >> settings [

	^ settings ifNil: [ settings := self retrieveSettingsIfPresent ]
]

{ #category : 'private' }
DockSettings >> settingsFileReference [

	^ self class settingsFileReference
]

{ #category : 'private' }
DockSettings >> store [
	
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
