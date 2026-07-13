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

{ #category : 'private' }
PulsarUpdater >> saveImage [

	[ Smalltalk snapshot: true andQuit: false ] fork.
	10 milliSeconds wait
]

{ #category : 'updating' }
PulsarUpdater >> update [

	OpalCompiler evaluate: self updateScript.
	
	logger info: 'Saving image...'.
	
	self saveImage.
	
	logger info: 'Update finished.'.
]

{ #category : 'private' }
PulsarUpdater >> updateScript [ 
	| downloadedContents |

	
	downloadedContents := self downloadUpdateFile.
	"fail fast because if the script is not correct, update will not work anyway"
	(downloadedContents beginsWith: 'MetaMetacello load:') 
		ifFalse: [ self error: 'Bad update script format.' ].
	
	"this is just a hack so I do not have in two different places the same content"
	^ downloadedContents
		copyReplaceAll: 'MetaMetacello load:' 
			with: 'MetaMetacello update:'
]
