"
I am an MCP tool for handling the repositories known to Pulsar.

I work on the repositories loaded in the Pulsar environment (the projects of the main browser), not on the global Iceberg registry. Read operations answer repository status, packages, branches, remotes, tags and working-copy changes. Actions (open and close a repository browser, commit, fetch, pull, push, switch or create a branch, add a package, recalculate dirty packages) go through PulsarRepositoryModel and broadcast PulsarRepositoryModified so open repository views stay in sync.

My tool name is pulsar-repository.
"
Class {
	#name : 'MCPPulsarRepository',
	#superclass : 'MCPPulsarTool',
	#category : 'Pulsar-Tool-LLM',
	#package : 'Pulsar-Tool-LLM'
}

{ #category : 'operations' }
MCPPulsarRepository >> addPackageForRequest: request [
	"Add a package to the repository named in the request."

	| repository packageName package |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	packageName := request stringArgumentNamed: 'packageName'.
	(packageName isNil or: [ packageName asString trimBoth isEmpty ]) ifTrue: [
			^ self errorResultText: 'packageName is required for addPackage.' details: {
					  (#operation -> 'addPackage').
					  (#name -> repository name asString) } asDictionary ].
	package := (self safeValue: [ repository allPackagesAvailableToAdd ] default: #(  ))
		           detect: [ :each | each name asString sameAs: packageName asString trimBoth ]
		           ifNone: [ nil ].
	package ifNil: [
			^ self
				  errorResultText: 'No package named ' , packageName printString , ' is available to add to ' , repository name asString , '.'
				  details: {
						  (#operation -> 'addPackage').
						  (#name -> repository name asString).
						  (#packageName -> packageName asString) } asDictionary ].
	^ [
		  repository addPackage: package.
		  self broadcastRepositoryModified: repository reason: (PulsarRepositoryModified newValue: repository).
		  self successResultText: 'Added package ' , packageName asString trimBoth , ' to ' , repository name asString , '.' data: {
				  (#operation -> 'addPackage').
				  (#name -> repository name asString).
				  (#packageName -> packageName asString trimBoth).
				  (#packageCount -> (self safeValue: [ repository packages size ] default: 0)) } asDictionary ]
		  on: Error
		  do: [ :error | self repositoryActionErrorResult: error operation: 'addPackage' for: repository ]
]

{ #category : 'private' }
MCPPulsarRepository >> branchSummaryTextFrom: aCollection [
	"Answer a one-line summary of branch dictionaries."

	^ aCollection isEmpty
		  ifTrue: [ 'none' ]
		  ifFalse: [
				  (aCollection collect: [ :each |
						   (each at: #name) , ((each at: #isHead)
							    ifTrue: [ '*' ]
							    ifFalse: [ '' ]) ]) joinUsing: ', ' ]
]

{ #category : 'private' }
MCPPulsarRepository >> broadcastRepositoryModified: aRepositoryModel reason: anAnnouncement [
	"Broadcast aRepositoryModified to all open Pulsar windows."

	| application |
	application := self pulsarApplication.
	application ifNil: [ ^ self ].
	application resendAnnouncement: anAnnouncement
]

{ #category : 'operations' }
MCPPulsarRepository >> closeForRequest: request [
	"Close the repository browser of the repository named in the request."

	| repository windows closed |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	windows := self repositoryBrowserWindowsFor: repository.
	windows isEmpty ifTrue: [
			^ self errorResultText: 'No repository browser is open for ' , repository name asString , '.' details: {
					  (#operation -> 'close').
					  (#name -> repository name asString) } asDictionary ].
	closed := self
		          safeValue: [
				          self onUIThreadDo: [ windows do: [ :each | each close ] ].
				          true ]
		          default: false.
	closed ifFalse: [
			^ self errorResultText: 'Could not close the repository browser of ' , repository name asString , '.' details: {
					  (#operation -> 'close').
					  (#name -> repository name asString) } asDictionary ].
	^ self successResultText: 'Closed the repository browser of ' , repository name asString , '.' data: {
			  (#operation -> 'close').
			  (#name -> repository name asString).
			  (#closed -> true).
			  (#windowCount -> windows size) } asDictionary
]

{ #category : 'operations' }
MCPPulsarRepository >> commitForRequest: request [
	"Commit the active changes of the repository named in the request."

	| repository message |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	message := request stringArgumentNamed: 'message'.
	(message isNil or: [ message asString trimBoth isEmpty ]) ifTrue: [
			^ self errorResultText: 'message is required for commit.' details: {
					  (#operation -> 'commit').
					  (#name -> repository name asString) } asDictionary ].
	^ [
		  repository commitChangesWithMessage: message asString trimBoth.
		  self broadcastRepositoryModified: repository reason: (PulsarRepositoryModified commit: repository).
		  self successResultText: 'Committed ' , repository name asString , '.' data: {
				  (#operation -> 'commit').
				  (#name -> repository name asString).
				  (#commitId -> (self safeValue: [ repository entity headCommit id asString ] default: '')) } asDictionary ]
		  on: Error
		  do: [ :error | self repositoryActionErrorResult: error operation: 'commit' for: repository ]
]

{ #category : 'private' }
MCPPulsarRepository >> commitSummariesFor: aCollection [
	"Answer up to 20 JSON-safe commit summaries."

	| commits |
	aCollection ifEmpty: [ ^ #(  ) ].
	commits := aCollection copyFrom: 1 to: (aCollection size min: 20).
	^ (commits collect: [ :each |
			   {
				   (#id -> (self safeValue: [ each id asString ] default: '')).
				   (#shortId -> (self safeValue: [ each shortId asString ] default: '')).
				   (#message -> (self safeValue: [ each comment asString truncateTo: 120 ] default: '')).
				   (#author -> (self safeValue: [ each author asString ] default: '')).
				   (#datetime -> (self safeValue: [ each datetime asString ] default: '')) } asDictionary ]) asArray
]

{ #category : 'operations' }
MCPPulsarRepository >> createBranchForRequest: request [
	"Create a branch in the repository named in the request and switch to it."

	| repository branchName wanted previousHeadName branches |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	branchName := request stringArgumentNamed: 'branchName'.
	(branchName isNil or: [ branchName asString trimBoth isEmpty ]) ifTrue: [
			^ self errorResultText: 'branchName is required for createBranch.' details: {
					  (#operation -> 'createBranch').
					  (#name -> repository name asString) } asDictionary ].
	wanted := branchName asString trimBoth.
	branches := self safeValue: [ repository localBranches ] default: #(  ).
	(branches anySatisfy: [ :each | each name asString sameAs: wanted ]) ifTrue: [
			^ self
				  errorResultText:
				  'Branch ' , wanted printString , ' already exists in ' , repository name asString , '. Use switchBranch to switch to it.'
				  details: {
						  (#operation -> 'createBranch').
						  (#name -> repository name asString).
						  (#branchName -> wanted) } asDictionary ].
	^ [
		  previousHeadName := self safeValue: [ repository headName asString ] default: ''.
		  repository switchToBranchNamed: wanted.
		  repository resetDiff.
		  self broadcastRepositoryModified: repository reason: (PulsarRepositoryModified branchCreated: repository).
		  self successResultText: 'Created branch ' , wanted , ' in ' , repository name asString , '.' data: {
				  (#operation -> 'createBranch').
				  (#name -> repository name asString).
				  (#branchName -> wanted).
				  (#previousHeadName -> previousHeadName) } asDictionary ]
		  on: Error
		  do: [ :error | self repositoryActionErrorResult: error operation: 'createBranch' for: repository ]
]

{ #category : 'accessing' }
MCPPulsarRepository >> defaultDescription [

	^ 'Handle the repositories known to Pulsar. operation=list lists the repositories loaded in the Pulsar environment, with their branch, status and open-browser state. operation=info describes one repository, including packages, branches, remotes, tags and commit counters. operation=diff lists the working-copy changes of a repository. Actions: operation=open and operation=close manage the repository browser dock; operation=commit commits the active changes with message; operation=fetch, operation=pull and operation=push synchronize with remotes (remoteName is optional); operation=switchBranch and operation=createBranch change branches; operation=addPackage adds a package to the repository; operation=recalculateDirtyPackages recomputes dirty packages. Use repositoryName to choose the repository, optionally with location to disambiguate. Actions go through PulsarRepositoryModel and keep open Pulsar views in sync.'
]

{ #category : 'accessing' }
MCPPulsarRepository >> defaultInputSchema [

	^ MCPStructureInputSchema new
		  type: 'object';
		  properties: {
				  (self
					   stringEnumSchemaPropertyNamed: 'operation'
					   description: 'The repository operation to perform.'
					   values:
						   #( 'list' 'info' 'diff' 'open' 'close' 'commit' 'fetch' 'pull' 'push' 'switchBranch' 'createBranch' 'addPackage'
						      'recalculateDirtyPackages' )).
				  (self
					   schemaPropertyNamed: 'repositoryName'
					   type: 'string'
					   description: 'The repository name, for example Pulsar or pulsar-remote-rpc. Required for every operation except list.').
				  (self
					   schemaPropertyNamed: 'location'
					   type: 'string'
					   description: 'A repository location fragment used to disambiguate repositories with similar names.').
				  (self schemaPropertyNamed: 'branchName' type: 'string' description: 'The branch name for switchBranch and createBranch.').
				  (self schemaPropertyNamed: 'message' type: 'string' description: 'The commit message for commit.').
				  (self schemaPropertyNamed: 'packageName' type: 'string' description: 'The package name for addPackage.').
				  (self
					   schemaPropertyNamed: 'remoteName'
					   type: 'string'
					   description: 'The remote name for fetch, pull and push. Defaults to the upstream remote.') };
		  required: #( 'operation' );
		  additionalProperties: true;
		  yourself
]

{ #category : 'accessing' }
MCPPulsarRepository >> defaultName [

	^ 'pulsar-repository'
]

{ #category : 'accessing' }
MCPPulsarRepository >> defaultOutputSchema [

	| repositorySchema packageSchema branchSchema commitSchema diffEntrySchema |
	repositorySchema := MCPStructureProperties new
		                    type: 'object';
		                    properties: {
				                    (self schemaPropertyNamed: 'name' type: 'string' description: 'The repository name.').
				                    (self schemaPropertyNamed: 'location' type: 'string' description: 'The repository location on disk.').
				                    (self schemaPropertyNamed: 'headName' type: 'string' description: 'The current head branch or tag name.').
				                    (self
					                     schemaPropertyNamed: 'status'
					                     type: 'string'
					                     description: 'The repository status: upToDate, modified, notLoaded, detached, missing or error.').
				                    (self schemaPropertyNamed: 'isDirty' type: 'boolean' description: 'Whether the working copy is modified.').
				                    (self
					                     schemaPropertyNamed: 'needsRepair'
					                     type: 'boolean'
					                     description: 'Whether the repository needs a repair action.').
				                    (self
					                     schemaPropertyNamed: 'isMissing'
					                     type: 'boolean'
					                     description: 'Whether the repository location is missing.').
				                    (self
					                     schemaPropertyNamed: 'isDetached'
					                     type: 'boolean'
					                     description: 'Whether the repository is on a detached head.').
				                    (self
					                     schemaPropertyNamed: 'isLocked'
					                     type: 'boolean'
					                     description: 'Whether all the repository baselines are locked.').
				                    (self
					                     schemaPropertyNamed: 'hasUpstream'
					                     type: 'boolean'
					                     description: 'Whether the current branch has an upstream.').
				                    (self
					                     schemaPropertyNamed: 'upstreamRemoteName'
					                     type: 'string'
					                     description: 'The upstream remote name, or an empty string.').
				                    (self
					                     schemaPropertyNamed: 'packageCount'
					                     type: 'integer'
					                     description: 'The number of packages managed by the repository.').
				                    (self
					                     schemaPropertyNamed: 'openWindowCount'
					                     type: 'integer'
					                     description: 'The number of open repository browser windows.').
				                    (self
					                     schemaPropertyNamed: 'outgoingCommitCount'
					                     type: 'integer'
					                     description: 'The number of commits ahead of the upstream.').
				                    (self
					                     schemaPropertyNamed: 'incomingCommitCount'
					                     type: 'integer'
					                     description: 'The number of commits behind the upstream.') };
		                    required: #( 'name' 'location' 'status' 'isDirty' 'needsRepair' 'packageCount' 'openWindowCount' );
		                    additionalProperties: true;
		                    yourself.
	packageSchema := MCPStructureProperties new
		                 type: 'object';
		                 properties: {
				                 (self schemaPropertyNamed: 'name' type: 'string' description: 'The package name.').
				                 (self
					                  schemaPropertyNamed: 'isBaseline'
					                  type: 'boolean'
					                  description: 'Whether the package is a baseline package.').
				                 (self
					                  schemaPropertyNamed: 'isLoaded'
					                  type: 'boolean'
					                  description: 'Whether the package is loaded in the image.').
				                 (self
					                  schemaPropertyNamed: 'isModified'
					                  type: 'boolean'
					                  description: 'Whether the package has image-side modifications.') };
		                 required: #( 'name' 'isBaseline' 'isLoaded' 'isModified' );
		                 additionalProperties: false;
		                 yourself.
	branchSchema := MCPStructureProperties new
		                type: 'object';
		                properties: {
				                (self schemaPropertyNamed: 'name' type: 'string' description: 'The branch name.').
				                (self schemaPropertyNamed: 'isHead' type: 'boolean' description: 'Whether the branch is the repository head.').
				                (self
					                 schemaPropertyNamed: 'isRemote'
					                 type: 'boolean'
					                 description: 'Whether the branch is a remote tracked branch.') };
		                required: #( 'name' 'isHead' 'isRemote' );
		                additionalProperties: false;
		                yourself.
	commitSchema := MCPStructureProperties new
		                type: 'object';
		                properties: {
				                (self schemaPropertyNamed: 'id' type: 'string' description: 'The full commit id.').
				                (self schemaPropertyNamed: 'shortId' type: 'string' description: 'The short commit id.').
				                (self schemaPropertyNamed: 'message' type: 'string' description: 'The first line of the commit message.').
				                (self schemaPropertyNamed: 'author' type: 'string' description: 'The commit author.').
				                (self schemaPropertyNamed: 'datetime' type: 'string' description: 'The commit date and time.') };
		                required: #( 'id' 'shortId' 'message' 'author' 'datetime' );
		                additionalProperties: false;
		                yourself.
	diffEntrySchema := MCPStructureProperties new
		                   type: 'object';
		                   properties: {
				                   (self
					                    schemaPropertyNamed: 'path'
					                    type: 'string'
					                    description: 'The repository-relative path of the changed artifact.').
				                   (self
					                    schemaPropertyNamed: 'status'
					                    type: 'string'
					                    description: 'The change status: added, removed, modified or conflicted.').
				                   (self
					                    schemaPropertyNamed: 'description'
					                    type: 'string'
					                    description: 'A printable description of the changed artifact.').
				                   (self
					                    schemaPropertyNamed: 'isActive'
					                    type: 'boolean'
					                    description: 'Whether the change is selected in the repository view.') };
		                   required: #( 'path' 'status' 'description' 'isActive' );
		                   additionalProperties: false;
		                   yourself.
	^ self
		  standardOutputSchemaForDataProperties: {
				  ((self schemaPropertyNamed: 'repositories' type: 'array' description: 'The repository summaries answered by operation=list.')
					   items: repositorySchema;
					   yourself).
				  ((self schemaPropertyNamed: 'repository' type: 'object' description: 'The repository answered by operation=info.')
					   additionalProperties: true;
					   yourself).
				  ((self
					    schemaPropertyNamed: 'packages'
					    type: 'array'
					    description: 'The packages of the repository answered by operation=info.')
					   items: packageSchema;
					   yourself).
				  ((self
					    schemaPropertyNamed: 'branches'
					    type: 'array'
					    description: 'The local and remote branches of the repository answered by operation=info.')
					   items: branchSchema;
					   yourself).
				  (self
					   stringArraySchemaNamed: 'remotes'
					   description: 'The remote names of the repository answered by operation=info.'
					   itemDescription: 'A remote name.').
				  (self
					   stringArraySchemaNamed: 'tags'
					   description: 'The tag names of the repository answered by operation=info.'
					   itemDescription: 'A tag name.').
				  ((self
					    schemaPropertyNamed: 'outgoingCommits'
					    type: 'array'
					    description: 'The commits ahead of the upstream answered by operation=info.')
					   items: commitSchema;
					   yourself).
				  ((self
					    schemaPropertyNamed: 'incomingCommits'
					    type: 'array'
					    description: 'The commits behind the upstream answered by operation=info.')
					   items: commitSchema;
					   yourself).
				  ((self schemaPropertyNamed: 'entries' type: 'array' description: 'The working-copy changes answered by operation=diff.')
					   items: diffEntrySchema;
					   yourself).
				  (self
					   stringArraySchemaNamed: 'windowTitles'
					   description: 'The titles of the repository browser windows.'
					   itemDescription: 'A window title.').
				  (self schemaPropertyNamed: 'operation' type: 'string' description: 'The operation that was performed.').
				  (self schemaPropertyNamed: 'name' type: 'string' description: 'The repository name the operation targeted.').
				  (self
					   schemaPropertyNamed: 'repositoryCount'
					   type: 'integer'
					   description: 'The number of repositories answered by operation=list.').
				  (self schemaPropertyNamed: 'opened' type: 'boolean' description: 'Whether operation=open opened a repository browser.').
				  (self schemaPropertyNamed: 'alreadyOpen' type: 'boolean' description: 'Whether the repository browser was already open.').
				  (self schemaPropertyNamed: 'closed' type: 'boolean' description: 'Whether operation=close closed a repository browser.').
				  (self
					   schemaPropertyNamed: 'windowCount'
					   type: 'integer'
					   description: 'The number of repository browser windows involved in the operation.').
				  (self schemaPropertyNamed: 'changeCount' type: 'integer' description: 'The number of changed artifacts.').
				  (self schemaPropertyNamed: 'isEmpty' type: 'boolean' description: 'Whether the working-copy diff has no entries.').
				  (self schemaPropertyNamed: 'commitId' type: 'string' description: 'The id of the commit created by operation=commit.').
				  (self schemaPropertyNamed: 'remoteName' type: 'string' description: 'The remote used by fetch, pull or push.').
				  (self schemaPropertyNamed: 'branchName' type: 'string' description: 'The branch used by switchBranch or createBranch.').
				  (self schemaPropertyNamed: 'previousHeadName' type: 'string' description: 'The head name before a branch operation.').
				  (self schemaPropertyNamed: 'packageName' type: 'string' description: 'The package used by operation=addPackage.').
				  (self schemaPropertyNamed: 'packageCount' type: 'integer' description: 'The number of packages after the operation.') }
		  required: #( 'operation' )
]

{ #category : 'private' }
MCPPulsarRepository >> defaultRemoteFor: aRepositoryModel [
	"Answer the only remote of aRepositoryModel, or nil when there is not exactly one."

	| remotes |
	remotes := self safeValue: [ aRepositoryModel remotes ] default: #(  ).
	^ remotes size = 1
		  ifTrue: [ remotes first ]
		  ifFalse: [ nil ]
]

{ #category : 'accessing' }
MCPPulsarRepository >> defaultTitle [

	^ 'Pulsar Repository'
]

{ #category : 'private' }
MCPPulsarRepository >> diffEntriesFor: aRepositoryModel [
	"Answer the working-copy changes of aRepositoryModel as JSON-safe dictionaries."

	| entries |
	entries := OrderedCollection new.
	aRepositoryModel diffNode withAllChildrenDo: [ :each |
			| node operation |
			node := each node.
			(node isKindOf: IceNode) ifTrue: [
					operation := node value.
					(operation isKindOf: IceOperation) ifTrue: [
							operation isNoModification ifFalse: [
									entries add: {
											(#path -> (self safeValue: [ node path segments joinUsing: '/' ] default: '')).
											(#status -> (self diffStatusFor: operation)).
											(#description -> (self safeValue: [ each description asString ] default: '')).
											(#isActive -> (self safeValue: [ each isActive ] default: true)) } asDictionary ] ] ] ].
	^ entries asArray
]

{ #category : 'operations' }
MCPPulsarRepository >> diffForRequest: request [
	"Answer the working-copy changes of the repository named in the request."

	| repository entries |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	^ [
		  entries := self diffEntriesFor: repository.
		  self successResultText: entries size printString , ' change(s) in ' , repository name asString , '.' data: {
				  (#operation -> 'diff').
				  (#name -> repository name asString).
				  (#changeCount -> entries size).
				  (#isEmpty -> entries isEmpty).
				  (#entries -> entries) } asDictionary ]
		  on: Error
		  do: [ :error |
				  self
					  errorResultText:
					  'Cannot compute the working-copy diff of ' , repository name asString , ': ' , (self messageTextFor: error)
					  details: {
							  (#operation -> 'diff').
							  (#name -> repository name asString) } asDictionary ]
]

{ #category : 'private' }
MCPPulsarRepository >> diffStatusFor: anIceOperation [
	"Answer the status name of an Iceberg operation."

	anIceOperation isAddition ifTrue: [ ^ 'added' ].
	anIceOperation isRemoval ifTrue: [ ^ 'removed' ].
	anIceOperation isConflict ifTrue: [ ^ 'conflicted' ].
	anIceOperation isModification ifTrue: [ ^ 'modified' ].
	^ 'unchanged'
]

{ #category : 'private - results' }
MCPPulsarRepository >> errorNoUpstreamRemoteFor: aRepositoryModel operation: operationName [
	"Answer an error result when there is no upstream and no default remote."

	^ self
		  errorResultText: 'Repository ' , aRepositoryModel name asString , ' has no upstream remote. Provide remoteName.'
		  details: {
				  (#operation -> operationName).
				  (#name -> aRepositoryModel name asString).
				  (#remotes -> (self remoteNamesFor: aRepositoryModel)) } asDictionary
]

{ #category : 'private - results' }
MCPPulsarRepository >> errorRepositoryForRequest: request [
	"Answer an error result when repositoryName did not resolve to a single repository."

	| name names |
	name := request stringArgumentNamed: 'repositoryName'.
	name ifNil: [
			^ self
				  errorResultText: 'repositoryName is required for this operation.'
				  details: { (#knownRepositories -> self repositoryNames) } asDictionary ].
	names := self repositoryNames select: [ :each | each includesSubstring: name asString trimBoth caseSensitive: false ].
	names isEmpty ifTrue: [ names := self repositoryNames ].
	names := names asArray.
	names size > 20 ifTrue: [ names := names copyFrom: 1 to: 20 ].
	^ self
		  errorResultText: 'No single repository matches ' , name printString , '. Use repositoryName with location to disambiguate.'
		  details: {
				  (#name -> name).
				  (#suggestions -> names) } asDictionary
]

{ #category : 'private - results' }
MCPPulsarRepository >> errorUnknownRemoteNamed: nameString for: aRepositoryModel [
	"Answer an error result for an unknown remote name."

	^ self errorResultText: 'No remote named ' , nameString printString , ' in ' , aRepositoryModel name asString , '.' details: {
			  (#name -> aRepositoryModel name asString).
			  (#remoteName -> nameString asString).
			  (#remotes -> (self remoteNamesFor: aRepositoryModel)) } asDictionary
]

{ #category : 'executing' }
MCPPulsarRepository >> executeWithRequest: request [
	"Dispatch to the operation named in the request."

	| operation |
	operation := request stringArgumentNamed: 'operation'.
	operation ifNil: [ ^ self errorResultText: 'operation is required.' details: Dictionary new ].
	operation = 'list' ifTrue: [ ^ self listRepositories ].
	operation = 'info' ifTrue: [ ^ self infoForRequest: request ].
	operation = 'diff' ifTrue: [ ^ self diffForRequest: request ].
	operation = 'open' ifTrue: [ ^ self openForRequest: request ].
	operation = 'close' ifTrue: [ ^ self closeForRequest: request ].
	operation = 'commit' ifTrue: [ ^ self commitForRequest: request ].
	operation = 'fetch' ifTrue: [ ^ self fetchForRequest: request ].
	operation = 'pull' ifTrue: [ ^ self pullForRequest: request ].
	operation = 'push' ifTrue: [ ^ self pushForRequest: request ].
	operation = 'switchBranch' ifTrue: [ ^ self switchBranchForRequest: request ].
	operation = 'createBranch' ifTrue: [ ^ self createBranchForRequest: request ].
	operation = 'addPackage' ifTrue: [ ^ self addPackageForRequest: request ].
	operation = 'recalculateDirtyPackages' ifTrue: [ ^ self recalculateDirtyPackagesForRequest: request ].
	^ self errorResultText: 'Unknown operation: ' , operation details: { (#operation -> operation) } asDictionary
]

{ #category : 'operations' }
MCPPulsarRepository >> fetchForRequest: request [
	"Fetch the repository named in the request."

	| repository remoteName remote |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	remoteName := request stringArgumentNamed: 'remoteName'.
	remote := self remoteNamed: remoteName in: repository.
	(remoteName notNil and: [ remote isNil ]) ifTrue: [ ^ self errorUnknownRemoteNamed: remoteName for: repository ].
	^ [
		  repository fetchRemote: remote.
		  self broadcastRepositoryModified: repository reason: (PulsarRepositoryModified fetch: repository).
		  self successResultText: 'Fetched ' , repository name asString , '.' data: {
				  (#operation -> 'fetch').
				  (#name -> repository name asString).
				  (#remoteName -> (self nameOfRemote: remote)) } asDictionary ]
		  on: Error
		  do: [ :error | self repositoryActionErrorResult: error operation: 'fetch' for: repository ]
]

{ #category : 'accessing' }
MCPPulsarRepository >> formattedDataContentBlocks: aDictionary [
	"Render the repository data as a text content block."

	| lines repositories repository entries |
	repositories := aDictionary at: #repositories ifAbsent: [ nil ].
	repositories ifNotNil: [ :collection |
			collection isEmpty ifTrue: [ ^ #(  ) ].
			lines := collection collectWithIndex: [ :each :index |
					         '[' , index printString , '] ' , (each at: #name) , ' (' , (each at: #status) , ', ' , (each at: #headName) , ') '
					         , (each at: #location) , ((each at: #isOpen)
						          ifTrue: [ ' [open]' ]
						          ifFalse: [ '' ]) ].
			^ { (self textContent: (lines joinUsing: String cr)) } ].
	repository := aDictionary at: #repository ifAbsent: [ nil ].
	repository ifNotNil: [ :each |
			lines := OrderedCollection new.
			lines add: (each at: #name) , ' - ' , (each at: #status).
			lines add: '  location: ' , (each at: #location).
			lines add: '  head: ' , (each at: #headName).
			lines add: '  packages: ' , (self packageSummaryTextFrom: (aDictionary at: #packages ifAbsent: [ #(  ) ])).
			lines add: '  branches: ' , (self branchSummaryTextFrom: (aDictionary at: #branches ifAbsent: [ #(  ) ])).
			lines add: '  remotes: ' , ((aDictionary at: #remotes ifAbsent: [ #(  ) ]) joinUsing: ', ').
			(aDictionary at: #tags ifAbsent: [ #(  ) ]) ifNotEmpty: [ :tags | lines add: '  tags: ' , (tags joinUsing: ', ') ].
			lines add:
				'  commits: ' , (each at: #outgoingCommitCount) printString , ' outgoing, ' , (each at: #incomingCommitCount) printString
				, ' incoming'.
			^ { (self textContent: (lines joinUsing: String cr)) } ].
	entries := aDictionary at: #entries ifAbsent: [ nil ].
	entries ifNotNil: [ :collection |
			lines := collection collect: [ :each | (each at: #status) , ' ' , (each at: #path) , '  ' , (each at: #description) ].
			^ { (self textContent: (lines isEmpty
					    ifTrue: [ 'No working-copy changes.' ]
					    ifFalse: [ lines joinUsing: String cr ])) } ].
	^ #(  )
]

{ #category : 'operations' }
MCPPulsarRepository >> infoForRequest: request [
	"Answer the details of the repository named in the request."

	| repository outgoing incoming |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	outgoing := self safeValue: [ repository outgoingCommits ] default: #(  ).
	incoming := self safeValue: [ repository incomingCommits ] default: #(  ).
	^ self successResultText: 'Repository ' , repository name asString , '.' data: {
			  (#operation -> 'info').
			  (#repository -> (self repositoryInfoFor: repository)).
			  (#packages -> (self repositoryPackagesFor: repository)).
			  (#branches -> (self repositoryBranchesFor: repository)).
			  (#remotes -> (self remoteNamesFor: repository)).
			  (#tags -> (self repositoryTagsFor: repository)).
			  (#outgoingCommits -> (self commitSummariesFor: outgoing)).
			  (#incomingCommits -> (self commitSummariesFor: incoming)) } asDictionary
]

{ #category : 'operations' }
MCPPulsarRepository >> listRepositories [
	"Answer the repositories loaded in Pulsar."

	| repositories |
	repositories := self repositories.
	^ self successResultText: repositories size printString , ' Pulsar repository(ies).' data: {
			  (#operation -> 'list').
			  (#repositoryCount -> repositories size).
			  (#repositories -> (repositories collect: [ :each | self repositorySummaryFor: each ]) asArray) } asDictionary
]

{ #category : 'private' }
MCPPulsarRepository >> locationStringFor: aRepositoryModel [
	"Answer the repository location as a string, or an empty string."

	^ [ aRepositoryModel location ifNil: [ '' ] ifNotNil: [ :file | file fullName ] ]
		  on: Error
		  do: [ :error | '' ]
]

{ #category : 'private' }
MCPPulsarRepository >> messageTextFor: anError [
	"Answer a printable message for anError."

	| text |
	(anError isKindOf: IceNothingToCommit) ifTrue: [ ^ 'nothing to commit' ].
	text := anError messageText ifNil: [ '' ] ifNotNil: [ :each | each asString ].
	text isEmpty ifTrue: [ text := anError class name ].
	^ text
]

{ #category : 'private' }
MCPPulsarRepository >> nameOfRemote: aRemote [
	"Answer the name of aRemote, or an empty string."

	^ aRemote ifNil: [ '' ] ifNotNil: [ :remote | remote name asString ]
]

{ #category : 'operations' }
MCPPulsarRepository >> openForRequest: request [
	"Open a repository browser for the repository named in the request."

	| repository windows opened |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	windows := self repositoryBrowserWindowsFor: repository.
	windows notEmpty ifTrue: [
			^ self successResultText: 'Repository ' , repository name asString , ' is already open.' data: {
					  (#operation -> 'open').
					  (#name -> repository name asString).
					  (#opened -> false).
					  (#alreadyOpen -> true).
					  (#windowCount -> windows size).
					  (#windowTitles -> (self windowTitlesFor: repository)) } asDictionary ].
	(self safeValue: [ repository needsRepair ] default: true) ifTrue: [
			^ self errorResultText: 'Repository ' , repository name asString , ' needs repair and cannot be opened.' details: {
					  (#operation -> 'open').
					  (#name -> repository name asString) } asDictionary ].
	opened := self
		          safeValue: [
				          self onUIThreadDo: [
						          (PulsarRepositoryBrowser newApplication: self pulsarApplication model: repository) open.
						          true ] ]
		          default: false.
	opened ifFalse: [
			^ self errorResultText: 'Could not open a repository browser for ' , repository name asString , '.' details: {
					  (#operation -> 'open').
					  (#name -> repository name asString) } asDictionary ].
	windows := self repositoryBrowserWindowsFor: repository.
	^ self successResultText: 'Opened repository ' , repository name asString , '.' data: {
			  (#operation -> 'open').
			  (#name -> repository name asString).
			  (#opened -> true).
			  (#alreadyOpen -> false).
			  (#windowCount -> windows size).
			  (#windowTitles -> (self windowTitlesFor: repository)) } asDictionary
]

{ #category : 'private' }
MCPPulsarRepository >> packageSummaryTextFrom: aCollection [
	"Answer a one-line summary of package dictionaries."

	^ aCollection isEmpty
		  ifTrue: [ '0' ]
		  ifFalse: [ aCollection size printString , ' (' , ((aCollection collect: [ :each | each at: #name ]) joinUsing: ', ') , ')' ]
]

{ #category : 'operations' }
MCPPulsarRepository >> pullForRequest: request [
	"Pull the repository named in the request."

	| repository remoteName remote |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	remoteName := request stringArgumentNamed: 'remoteName'.
	remote := self remoteNamed: remoteName in: repository.
	(remoteName notNil and: [ remote isNil ]) ifTrue: [ ^ self errorUnknownRemoteNamed: remoteName for: repository ].
	(remoteName isNil and: [ (self safeValue: [ repository hasUpstream ] default: false) not ]) ifTrue: [
			remote := self defaultRemoteFor: repository.
			remote ifNil: [ ^ self errorNoUpstreamRemoteFor: repository operation: 'pull' ] ].
	^ [
		  repository pullFromRemote: remote.
		  self broadcastRepositoryModified: repository reason: (PulsarRepositoryModified pull: repository).
		  self successResultText: 'Pulled ' , repository name asString , '.' data: {
				  (#operation -> 'pull').
				  (#name -> repository name asString).
				  (#remoteName -> (self nameOfRemote: remote)) } asDictionary ]
		  on: Error
		  do: [ :error | self repositoryActionErrorResult: error operation: 'pull' for: repository ]
]

{ #category : 'operations' }
MCPPulsarRepository >> pushForRequest: request [
	"Push the repository named in the request."

	| repository remoteName remote |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	remoteName := request stringArgumentNamed: 'remoteName'.
	remote := self remoteNamed: remoteName in: repository.
	(remoteName notNil and: [ remote isNil ]) ifTrue: [ ^ self errorUnknownRemoteNamed: remoteName for: repository ].
	(remoteName isNil and: [ (self safeValue: [ repository hasUpstream ] default: false) not ]) ifTrue: [
			remote := self defaultRemoteFor: repository.
			remote ifNil: [ ^ self errorNoUpstreamRemoteFor: repository operation: 'push' ] ].
	^ [
		  repository pushToRemote: remote.
		  self broadcastRepositoryModified: repository reason: (PulsarRepositoryModified push: repository).
		  self successResultText: 'Pushed ' , repository name asString , '.' data: {
				  (#operation -> 'push').
				  (#name -> repository name asString).
				  (#remoteName -> (self nameOfRemote: remote)) } asDictionary ]
		  on: Error
		  do: [ :error | self repositoryActionErrorResult: error operation: 'push' for: repository ]
]

{ #category : 'operations' }
MCPPulsarRepository >> recalculateDirtyPackagesForRequest: request [
	"Recalculate the dirty packages of the repository named in the request."

	| repository |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	^ [
		  repository recalculateDirtyChanges.
		  self broadcastRepositoryModified: repository reason: (PulsarRepositoryModified newValue: repository).
		  self successResultText: 'Recalculated dirty packages of ' , repository name asString , '.' data: {
				  (#operation -> 'recalculateDirtyPackages').
				  (#name -> repository name asString).
				  (#packageCount -> (self safeValue: [ repository packages size ] default: 0)) } asDictionary ]
		  on: Error
		  do: [ :error | self repositoryActionErrorResult: error operation: 'recalculateDirtyPackages' for: repository ]
]

{ #category : 'private' }
MCPPulsarRepository >> remoteNamed: nameString in: aRepositoryModel [
	"Answer the remote of aRepositoryModel named nameString, or nil."

	| remotes |
	nameString ifNil: [ ^ nil ].
	remotes := self safeValue: [ aRepositoryModel remotes ] default: #(  ).
	^ remotes detect: [ :each | each name asString sameAs: nameString asString trimBoth ] ifNone: [ nil ]
]

{ #category : 'private' }
MCPPulsarRepository >> remoteNamesFor: aRepositoryModel [
	"Answer the remote names of aRepositoryModel."

	^ self safeValue: [ (aRepositoryModel remotes collect: [ :each | each name asString ]) asArray ] default: #(  )
]

{ #category : 'accessing' }
MCPPulsarRepository >> repositories [
	"Answer the repository models loaded in the Pulsar environment."

	| browser |
	browser := self mainBrowser.
	browser ifNil: [ ^ #(  ) ].
	^ (PulsarRepositoriesModel on: browser model) repositories
]

{ #category : 'private - results' }
MCPPulsarRepository >> repositoryActionErrorResult: anError operation: operationName for: aRepositoryModel [
	"Answer an error result for a failed repository action."

	^ self errorResultText: 'Repository operation ' , operationName , ' failed: ' , (self messageTextFor: anError) details: {
			  (#operation -> operationName).
			  (#name -> aRepositoryModel name asString) } asDictionary
]

{ #category : 'private' }
MCPPulsarRepository >> repositoryBranchesFor: aRepositoryModel [
	"Answer the local and remote branches of aRepositoryModel as JSON-safe dictionaries."

	^ Array streamContents: [ :stream |
			  (self safeValue: [ aRepositoryModel localBranches ] default: #(  )) do: [ :each |
					  stream nextPut: {
							  (#name -> each name asString).
							  (#isHead -> (self safeValue: [ each isHead ] default: false)).
							  (#isRemote -> false) } asDictionary ].
			  (self safeValue: [ aRepositoryModel remoteBranches ] default: #(  )) do: [ :each |
					  stream nextPut: {
							  (#name -> each name asString).
							  (#isHead -> (self safeValue: [ each isHead ] default: false)).
							  (#isRemote -> true) } asDictionary ] ]
]

{ #category : 'accessing' }
MCPPulsarRepository >> repositoryBrowserWindowsFor: aRepositoryModel [
	"Answer the open repository browser windows that show aRepositoryModel."

	| application |
	application := self pulsarApplication.
	application ifNil: [ ^ #(  ) ].
	^ (application windows select: [ :each | (each isKindOf: PulsarRepositoryBrowser) and: [ each model = aRepositoryModel ] ])
		  asArray
]

{ #category : 'private' }
MCPPulsarRepository >> repositoryForRequest: request [
	"Answer the repository model named in the request, or nil."

	| name |
	name := request stringArgumentNamed: 'repositoryName'.
	name ifNil: [ ^ nil ].
	^ self repositoryNamed: name location: (request stringArgumentNamed: 'location')
]

{ #category : 'private' }
MCPPulsarRepository >> repositoryInfoFor: aRepositoryModel [
	"Answer a JSON-safe description of aRepositoryModel."

	| windows |
	windows := self repositoryBrowserWindowsFor: aRepositoryModel.
	^ {
		  (#name -> aRepositoryModel name asString).
		  (#location -> (self locationStringFor: aRepositoryModel)).
		  (#headName -> (self safeValue: [ aRepositoryModel headName asString ] default: '')).
		  (#status -> (self safeValue: [ aRepositoryModel status asString ] default: 'error')).
		  (#isDirty -> (self safeValue: [ aRepositoryModel isDirty ] default: false)).
		  (#needsRepair -> (self safeValue: [ aRepositoryModel needsRepair ] default: true)).
		  (#isMissing -> (self safeValue: [ aRepositoryModel isMissing ] default: true)).
		  (#isDetached -> (self safeValue: [ aRepositoryModel isDetached ] default: false)).
		  (#isLocked -> (self safeValue: [ aRepositoryModel isLocked ] default: false)).
		  (#hasUpstream -> (self safeValue: [ aRepositoryModel hasUpstream ] default: false)).
		  (#upstreamRemoteName -> (self safeValue: [ aRepositoryModel entity branch upstream remote name asString ] default: '')).
		  (#packageCount -> (self safeValue: [ aRepositoryModel packages size ] default: 0)).
		  (#openWindowCount -> windows size).
		  (#outgoingCommitCount -> (self safeValue: [ aRepositoryModel outgoingCommits size ] default: 0)).
		  (#incomingCommitCount -> (self safeValue: [ aRepositoryModel incomingCommits size ] default: 0)) } asDictionary
]

{ #category : 'private' }
MCPPulsarRepository >> repositoryNamed: nameString location: locationString [
	"Answer the single repository matching nameString and locationString, or nil."

	| all wanted location matches candidates |
	all := self repositories.
	wanted := nameString asString trimBoth.
	wanted isEmpty ifTrue: [ ^ nil ].
	location := locationString ifNil: [ nil ] ifNotNil: [ :each | each asString trimBoth ].
	matches := all select: [ :each | each name asString sameAs: wanted ].
	matches isEmpty ifTrue: [
			matches := all select: [ :each |
					           (each name asString includesSubstring: wanted caseSensitive: false) or: [
						           (self locationStringFor: each) includesSubstring: wanted caseSensitive: false ] ] ].
	location ifNotNil: [ :fragment |
		matches := matches select: [ :each | (self locationStringFor: each) includesSubstring: fragment caseSensitive: false ] ].
	matches size = 1 ifTrue: [ ^ matches first ].
	matches isEmpty ifTrue: [ ^ nil ].
	candidates := matches select: [ :each | (self locationStringFor: each) = location ].
	^ candidates size = 1
		  ifTrue: [ candidates first ]
		  ifFalse: [ nil ]
]

{ #category : 'private' }
MCPPulsarRepository >> repositoryNames [
	"Answer the names of the repositories loaded in Pulsar."

	^ (self repositories collect: [ :each | each name asString ]) asSortedCollection asArray
]

{ #category : 'private' }
MCPPulsarRepository >> repositoryPackagesFor: aRepositoryModel [
	"Answer the packages of aRepositoryModel as JSON-safe dictionaries."

	^ self
		  safeValue: [
				  (aRepositoryModel packages collect: [ :each |
						   {
							   (#name -> each name asString).
							   (#isBaseline -> (self safeValue: [ each isBaseline ] default: false)).
							   (#isLoaded -> (self safeValue: [ each isLoaded ] default: false)).
							   (#isModified -> (self safeValue: [ each package isModified ] default: false)) } asDictionary ]) asArray ]
		  default: #(  )
]

{ #category : 'private' }
MCPPulsarRepository >> repositorySummaryFor: aRepositoryModel [
	"Answer a JSON-safe summary of aRepositoryModel."

	| windows |
	windows := self repositoryBrowserWindowsFor: aRepositoryModel.
	^ {
		  (#name -> aRepositoryModel name asString).
		  (#location -> (self locationStringFor: aRepositoryModel)).
		  (#headName -> (self safeValue: [ aRepositoryModel headName asString ] default: '')).
		  (#status -> (self safeValue: [ aRepositoryModel status asString ] default: 'error')).
		  (#isDirty -> (self safeValue: [ aRepositoryModel isDirty ] default: false)).
		  (#needsRepair -> (self safeValue: [ aRepositoryModel needsRepair ] default: true)).
		  (#isMissing -> (self safeValue: [ aRepositoryModel isMissing ] default: true)).
		  (#isDetached -> (self safeValue: [ aRepositoryModel isDetached ] default: false)).
		  (#packageCount -> (self safeValue: [ aRepositoryModel packages size ] default: 0)).
		  (#isOpen -> windows notEmpty).
		  (#openWindowCount -> windows size) } asDictionary
]

{ #category : 'private' }
MCPPulsarRepository >> repositoryTagsFor: aRepositoryModel [
	"Answer the tag names of aRepositoryModel."

	^ self safeValue: [ (aRepositoryModel tags collect: [ :each | each name asString ]) asArray ] default: #(  )
]

{ #category : 'private' }
MCPPulsarRepository >> safeValue: aBlock default: aDefault [
	"Answer the value of aBlock, or aDefault when it raises an error."

	^ [ aBlock value ]
		  on: Error
		  do: [ :error | aDefault ]
]

{ #category : 'operations' }
MCPPulsarRepository >> switchBranchForRequest: request [
	"Switch the repository named in the request to an existing local branch."

	| repository branchName wanted previousHeadName branches |
	repository := self repositoryForRequest: request.
	repository ifNil: [ ^ self errorRepositoryForRequest: request ].
	branchName := request stringArgumentNamed: 'branchName'.
	(branchName isNil or: [ branchName asString trimBoth isEmpty ]) ifTrue: [
			^ self errorResultText: 'branchName is required for switchBranch.' details: {
					  (#operation -> 'switchBranch').
					  (#name -> repository name asString) } asDictionary ].
	wanted := branchName asString trimBoth.
	branches := self safeValue: [ repository localBranches ] default: #(  ).
	(branches anySatisfy: [ :each | each name asString sameAs: wanted ]) ifFalse: [
			^ self
				  errorResultText:
				  'No local branch named ' , wanted printString , ' in ' , repository name asString , '. Use createBranch to create it.'
				  details: {
						  (#operation -> 'switchBranch').
						  (#name -> repository name asString).
						  (#branchName -> wanted).
						  (#branches -> (self safeValue: [ (branches collect: [ :each | each name asString ]) asArray ] default: #(  ))) }
						  asDictionary ].
	^ [
		  previousHeadName := self safeValue: [ repository headName asString ] default: ''.
		  repository switchToBranchNamed: wanted.
		  repository resetDiff.
		  self broadcastRepositoryModified: repository reason: (PulsarRepositoryModified checkout: repository).
		  self successResultText: 'Switched ' , repository name asString , ' to branch ' , wanted , '.' data: {
				  (#operation -> 'switchBranch').
				  (#name -> repository name asString).
				  (#branchName -> wanted).
				  (#previousHeadName -> previousHeadName) } asDictionary ]
		  on: Error
		  do: [ :error | self repositoryActionErrorResult: error operation: 'switchBranch' for: repository ]
]

{ #category : 'accessing' }
MCPPulsarRepository >> windowTitlesFor: aRepositoryModel [
	"Answer the titles of the open repository browser windows of aRepositoryModel."

	^ ((self repositoryBrowserWindowsFor: aRepositoryModel) collect: [ :each |
		   each title ifNil: [ '' ] ifNotNil: [ :title | title asString ] ]) asArray
]
