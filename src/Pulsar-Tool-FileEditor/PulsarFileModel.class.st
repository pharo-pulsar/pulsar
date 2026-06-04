"
A model representing an arbitrary text file opened for editing in Pulsar.

It wraps a FileReference as its entity and provides source code access, file writing, and editor class resolution for the file editor tool.
"
Class {
	#name : 'PulsarFileModel',
	#superclass : 'PvBaseModel',
	#category : 'Pulsar-Tool-FileEditor-Model',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Model'
}

{ #category : 'accessing - languages' }
PulsarFileModel class >> languageForExtension: anExtensionString [
	"Answer the GtkSourceView language ID for a file extension."

	anExtensionString = 'st' ifTrue: [ ^ 'smalltalk' ].
	anExtensionString = 'py' ifTrue: [ ^ 'python' ].
	anExtensionString = 'js' ifTrue: [ ^ 'javascript' ].
	anExtensionString = 'json' ifTrue: [ ^ 'json' ].
	anExtensionString = 'yml' ifTrue: [ ^ 'yaml' ].
	anExtensionString = 'yaml' ifTrue: [ ^ 'yaml' ].
	anExtensionString = 'xml' ifTrue: [ ^ 'xml' ].
	anExtensionString = 'html' ifTrue: [ ^ 'html' ].
	anExtensionString = 'css' ifTrue: [ ^ 'css' ].
	anExtensionString = 'c' ifTrue: [ ^ 'c' ].
	anExtensionString = 'cpp' ifTrue: [ ^ 'cpp' ].
	anExtensionString = 'h' ifTrue: [ ^ 'c' ].
	anExtensionString = 'sh' ifTrue: [ ^ 'sh' ].
	anExtensionString = 'md' ifTrue: [ ^ 'markdown' ].
	anExtensionString = 'toml' ifTrue: [ ^ 'toml' ].
	anExtensionString = 'ini' ifTrue: [ ^ 'ini' ].
	anExtensionString = 'cfg' ifTrue: [ ^ 'ini' ].
	anExtensionString = 'sql' ifTrue: [ ^ 'sql' ].
	anExtensionString = 'rb' ifTrue: [ ^ 'ruby' ].
	anExtensionString = 'rs' ifTrue: [ ^ 'rust' ].
	anExtensionString = 'go' ifTrue: [ ^ 'go' ].
	anExtensionString = 'java' ifTrue: [ ^ 'java' ].
	anExtensionString = 'ts' ifTrue: [ ^ 'typescript' ].
	anExtensionString = 'tsx' ifTrue: [ ^ 'typescript' ].
	anExtensionString = 'scala' ifTrue: [ ^ 'scala' ].
	anExtensionString = 'kt' ifTrue: [ ^ 'kotlin' ].
	anExtensionString = 'swift' ifTrue: [ ^ 'swift' ].
	^ nil
]

{ #category : 'accessing' }
PulsarFileModel >> fullName [

	^ self entity fullName
]

{ #category : 'testing' }
PulsarFileModel >> hasPulsarEditor [

	^ true
]

{ #category : 'accessing' }
PulsarFileModel >> name [

	^ self entity basename
]

{ #category : 'accessing' }
PulsarFileModel >> pageTitle [

	^ self entity basename
]

{ #category : 'accessing - ui' }
PulsarFileModel >> pulsarEditorClass [

	^ PulsarFileEditor
]

{ #category : 'accessing' }
PulsarFileModel >> sourceCode [

	^ self entity contents
]

{ #category : 'accessing' }
PulsarFileModel >> sourceCodeLanguage [
	"Return the GtkSourceView language identifier for this file, auto-detected from its extension."

	^ self entity extension ifEmpty: [ nil ] ifNotEmpty: [ :ext | self class languageForExtension: ext asLowercase ]
]

{ #category : 'accessing' }
PulsarFileModel >> spotterTitle [

	^ self entity basename
]

{ #category : 'updating' }
PulsarFileModel >> updateWith: aString notifying: anInteractionModel [
	"Write the edited content back to the file."

	self entity writeStreamDo: [ :stream | stream nextPutAll: aString ].
	^ true
]

{ #category : 'accessing' }
PulsarFileModel >> windowTitle [

	^ self entity basename
]
