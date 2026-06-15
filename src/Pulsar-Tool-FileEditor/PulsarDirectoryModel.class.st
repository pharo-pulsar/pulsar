"
A model representing a directory in the file system for the directory tree view.

It wraps a FileReference pointing to a directory and provides lazy children enumeration (subdirectories and files), along with display properties for the tree view.
"
Class {
	#name : 'PulsarDirectoryModel',
	#superclass : 'PvBaseModel',
	#category : 'Pulsar-Tool-FileEditor-Model',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Model'
}

{ #category : 'testing' }
PulsarDirectoryModel >> canBeActivated [

	^ false
]

{ #category : 'accessing' }
PulsarDirectoryModel >> children [
	"Return child models: subdirectories (as PulsarDirectoryModel) followed by files (as PulsarFileModel), sorted by name."

	| directoryModels fileModels |
	directoryModels := self entity directories
		                   collect: [ :each | PulsarDirectoryModel newEnvironment: self environmentModel parent: self entity: each ]
		                   as: OrderedCollection.

	fileModels := self entity files
		              collect: [ :each | PulsarFileModel newEnvironment: self environmentModel parent: self entity: each ]
		              as: OrderedCollection.

	directoryModels sort: [ :aModel :bModel | aModel name <= bModel name ].
	fileModels sort: [ :aModel :bModel | aModel name <= bModel name ].

	^ directoryModels
		  addAll: fileModels;
		  yourself
]

{ #category : 'accessing' }
PulsarDirectoryModel >> fullName [

	^ self entity fullName
]

{ #category : 'testing' }
PulsarDirectoryModel >> hasPulsarEditor [

	^ true
]

{ #category : 'accessing - ui' }
PulsarDirectoryModel >> iconName [

	^ 'file-extension-folder'
]

{ #category : 'testing' }
PulsarDirectoryModel >> isDirectory [

	^ true
]

{ #category : 'testing' }
PulsarDirectoryModel >> matches: aString [

	^ self name includesSubstring: aString caseSensitive: false
]

{ #category : 'accessing' }
PulsarDirectoryModel >> name [

	^ self entity basename
]

{ #category : 'actions' }
PulsarDirectoryModel >> openInOSFileBrowser [

	^ self entity openInOSFileBrowser
]

{ #category : 'accessing - ui' }
PulsarDirectoryModel >> pulsarEditorClass [

	^ PulsarDirectoryBrowser
]

{ #category : 'accessing' }
PulsarDirectoryModel >> spotterTitle [

	^ self entity basename
]

{ #category : 'accessing' }
PulsarDirectoryModel >> title [
	| fullName |
	
	self flag: #WINDOWS_FIX. "This will not work on windows"
	fullName := self fullName.
	
	^ fullName size > 20
		ifTrue: [ '.../', (fullName copyAfterLast: $/) ]
		ifFalse: [ fullName ]
]
