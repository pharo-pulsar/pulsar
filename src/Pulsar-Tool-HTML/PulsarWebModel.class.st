"
A model representing a web page opened in Pulsar's web editor.

It wraps a `ZnUrl` as its entity and resolves the editor class (`PulsarWebEditor`), display metadata (name, icon) and local-file operations for `file://` URLs. The file tree creates instances for HTML files, but the model also supports arbitrary remote URLs.
"
Class {
	#name : 'PulsarWebModel',
	#superclass : 'PvBaseModel',
	#category : 'Pulsar-Tool-HTML-Model',
	#package : 'Pulsar-Tool-HTML',
	#tag : 'Model'
}

{ #category : 'testing' }
PulsarWebModel class >> handlesFile: aFileReference [
	"Answer whether the receiver handles the given file, i.e. it is an HTML file to be rendered as a web page."

	^ #( 'html' 'htm' ) includes: aFileReference extension asLowercase
]

{ #category : 'actions' }
PulsarWebModel >> delete [
	"Delete the underlying file when the receiver points to the local filesystem."

	self fileReference ifNotNil: [ :aFileReference | aFileReference ensureDelete ]
]

{ #category : 'private' }
PulsarWebModel >> fileExtension [

	| segments last |
	segments := self pathSegments.
	segments ifEmpty: [ ^ '' ].
	last := segments last.
	^ (last includes: $.)
		  ifTrue: [ (last copyAfterLast: $.) asLowercase ]
		  ifFalse: [ '' ]
]

{ #category : 'private' }
PulsarWebModel >> fileReference [
	"Answer the local file behind the receiver when the URL is a file:// URL, otherwise nil."

	^ self entity scheme = #file
		  ifTrue: [ self entity path asFileReference ]
		  ifFalse: [ nil ]
]

{ #category : 'accessing' }
PulsarWebModel >> fullName [

	^ self entity asString
]

{ #category : 'accessing' }
PulsarWebModel >> iconName [

	(#( 'html' 'htm' ) includes: self fileExtension) ifTrue: [ ^ 'file-extension-html' ].
	^ nil
]

{ #category : 'testing' }
PulsarWebModel >> isDirectory [

	^ false
]

{ #category : 'testing' }
PulsarWebModel >> matches: aString [

	^ self name includesSubstring: aString caseSensitive: false
]

{ #category : 'accessing' }
PulsarWebModel >> name [
	"Answer a short display name: the last URL path segment, otherwise the host, otherwise the full URL."

	| segments host |
	segments := self pathSegments.
	segments ifNotEmpty: [ :each | ^ each last ].
	host := self entity host.
	(host notNil and: [ host notEmpty ]) ifTrue: [ ^ host ].
	^ self entity asString
]

{ #category : 'actions' }
PulsarWebModel >> openInOSFileBrowser [

	^ self fileReference ifNotNil: [ :aFileReference | aFileReference openInOSFileBrowser ] ifNil: [ nil ]
]

{ #category : 'accessing' }
PulsarWebModel >> pageTitle [

	^ self name
]

{ #category : 'private' }
PulsarWebModel >> pathSegments [
	"Answer the URL path segments, or an empty collection when the URL has no path."

	^ self entity segments ifNil: [ #(  ) ]
]

{ #category : 'accessing' }
PulsarWebModel >> pulsarEditorClass [

	^ PulsarWebEditor
]

{ #category : 'accessing' }
PulsarWebModel >> spotterTitle [

	^ self name
]

{ #category : 'accessing' }
PulsarWebModel >> url [
	"Answer the URL exposed by the receiver."

	^ self entity
]

{ #category : 'accessing' }
PulsarWebModel >> windowTitle [

	^ self name
]
