Class {
	#name : 'PulsarUpdater',
	#superclass : 'Object',
	#category : 'Pulsar-Browser-Utilities',
	#package : 'Pulsar-Browser',
	#tag : 'Utilities'
}

{ #category : 'updating' }
PulsarUpdater class >> update [

	^ self new update
]

{ #category : 'private' }
PulsarUpdater >> downloadUpdateFile [

	^ ZnClient new
		url: self loadScriptUrl;
		numberOfRetries: 5;
		timeout: 100;
		loggingOn;
		get;
		contents
]

{ #category : 'private' }
PulsarUpdater >> loadScriptUrl [

	^ 'https://forge.smallworks.eu/pharo/Pulsar/raw/branch/main/.ci/scripts/Load.st'
]

{ #category : 'updating' }
PulsarUpdater >> update [

	OpalCompiler evaluate: self updateContent.
	
	self saveImage
]

{ #category : 'private' }
PulsarUpdater >> updateScript [ 

	"this is just a hack so I do not have in two different places the same content"
	^ self downloadUpdateFile
			copyReplaceAll: 'MetaMetacello load:' 
			with: 'MetaMetacello update:'
]
