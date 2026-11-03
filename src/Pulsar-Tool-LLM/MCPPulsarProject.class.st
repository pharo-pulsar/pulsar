"
I am the MCP tool that opens and closes projects in the project tree of the running Pulsar IDE.

I address open Pulsar browser windows by a 1-based index, main browser first, and projects by name. A project name is the name shown in the tree, for example Pulsar for BaselineOfPulsar; I also accept the full baseline class name and ignore case. I expose three operations: list the browser windows with their open projects, open a baseline project, and close an open project. Closing only removes the project from the browser tree, exactly like the Close project action, and never deletes code.

I build on MCPPulsarTool, which gives me the running PulsarApplication and the GTK main-loop marshalling I use to change the browser tree.
"
Class {
	#name : 'MCPPulsarProject',
	#superclass : 'MCPPulsarTool',
	#category : 'Pulsar-Tool-LLM-MCP-Tools',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'MCP-Tools'
}

{ #category : 'private' }
MCPPulsarProject >> baselineNamed: nameString inBrowser: aBrowser [
	"Answer the baseline class matching nameString, or nil."

	| candidate baselines |
	candidate := nameString asString trimBoth.
	(candidate asLowercase beginsWith: 'baselineof') ifFalse: [ candidate := 'BaselineOf' , candidate ].
	baselines := aBrowser projectView model allBaselines.
	^ baselines detect: [ :each | each name sameAs: candidate ] ifNone: [ nil ]
]

{ #category : 'private' }
MCPPulsarProject >> browserAt: anIndex [
	"Answer the Pulsar browser at anIndex, or nil."

	| browsers |
	browsers := self projectBrowsers.
	^ (anIndex between: 1 and: browsers size)
		  ifTrue: [ browsers at: anIndex ]
		  ifFalse: [ nil ]
]

{ #category : 'private' }
MCPPulsarProject >> browserInfoFor: aBrowser index: anIndex [
	"Answer a structured description of a browser window and its projects. Run on the UI thread."

	| projects |
	projects := aBrowser projectView openedProjects.
	^ {
		  (#browserIndex -> anIndex).
		  (#title -> (aBrowser title ifNil: [ '' ])).
		  (#projectCount -> projects size).
		  (#projects
		   -> (projects collectWithIndex: [ :eachProject :eachIndex | self projectInfoFor: eachProject index: eachIndex ]) asArray) }
		  asDictionary
]

{ #category : 'operations' }
MCPPulsarProject >> closeProjectNamed: nameString browserIndex: anIndex [
	"Close the open project matching nameString in the browser at anIndex."

	| browser removed projects |
	browser := self browserAt: anIndex.
	browser ifNil: [ ^ self errorNoBrowserAt: anIndex ].
	removed := self onUIThreadDo: [ browser projectView removeProjectNamed: nameString ].
	removed ifNil: [ ^ self errorNoOpenProjectNamed: nameString inBrowser: browser ].
	projects := self onUIThreadDo: [
			            browser projectView openedProjects collectWithIndex: [ :eachProject :eachIndex |
				            self projectInfoFor: eachProject index: eachIndex ] ].
	^ self successResultText: 'Closed ' , removed name asString , ' in browser ' , anIndex printString , '.' data: {
			  (#operation -> 'close').
			  (#browserIndex -> anIndex).
			  (#name -> removed name asString).
			  (#kind -> (removed isVolatileProject
				    ifTrue: [ 'volatile' ]
				    ifFalse: [ 'baseline' ])).
			  (#closed -> true).
			  (#projectCount -> projects size).
			  (#projects -> projects asArray) } asDictionary
]

{ #category : 'accessing' }
MCPPulsarProject >> defaultDescription [

	^ 'Open and close projects in the project tree of open Pulsar browsers. operation=list lists the browser windows and their open projects. operation=open opens the baseline project matching name, for example Pulsar or BaselineOfPulsar. operation=close removes an open project from the browser tree without deleting any code. browserIndex selects the browser window, 1-based and main browser first, and defaults to 1.'
]

{ #category : 'accessing' }
MCPPulsarProject >> defaultInputSchema [

	^ MCPStructureInputSchema new
		  type: 'object';
		  properties: {
				  (self
					   stringEnumSchemaPropertyNamed: 'operation'
					   description: 'The project operation to perform.'
					   values: #( 'list' 'open' 'close' )).
				  (self
					   schemaPropertyNamed: 'name'
					   type: 'string'
					   description: 'The project name, for example Pulsar or BaselineOfPulsar. Required for open and close.').
				  ((self
					    integerSchemaPropertyNamed: 'browserIndex'
					    description: 'The 1-based index of the browser window, main browser first. Defaults to 1.')
					   default: 1;
					   yourself) };
		  required: #( 'operation' );
		  additionalProperties: true;
		  yourself
]

{ #category : 'accessing' }
MCPPulsarProject >> defaultName [

	^ 'pulsar-project'
]

{ #category : 'accessing' }
MCPPulsarProject >> defaultOutputSchema [

	| projectItemSchema browserItemSchema |
	projectItemSchema := MCPStructureProperties new
		                     type: 'object';
		                     properties: {
				                     (self
					                      schemaPropertyNamed: 'index'
					                      type: 'integer'
					                      description: '1-based index of the project in the browser tree.').
				                     (self schemaPropertyNamed: 'name' type: 'string' description: 'The project name.').
				                     (self schemaPropertyNamed: 'kind' type: 'string' description: 'The project kind: baseline or volatile.').
				                     (self
					                      schemaPropertyNamed: 'modified'
					                      type: 'boolean'
					                      description: 'Whether the project repository has uncommitted changes.') };
		                     required: #( 'index' 'name' 'kind' 'modified' );
		                     additionalProperties: false;
		                     yourself.
	browserItemSchema := MCPStructureProperties new
		                     type: 'object';
		                     properties: {
				                     (self
					                      schemaPropertyNamed: 'browserIndex'
					                      type: 'integer'
					                      description: '1-based index of the browser window, main browser first.').
				                     (self schemaPropertyNamed: 'title' type: 'string' description: 'The browser window title.').
				                     (self
					                      schemaPropertyNamed: 'projectCount'
					                      type: 'integer'
					                      description: 'Number of open projects in the browser.').
				                     ((self
					                       schemaPropertyNamed: 'projects'
					                       type: 'array'
					                       description: 'The open projects in the browser tree.')
					                      items: projectItemSchema;
					                      yourself) };
		                     required: #( 'browserIndex' 'title' 'projectCount' 'projects' );
		                     additionalProperties: false;
		                     yourself.
	^ self
		  standardOutputSchemaForDataProperties: {
				  ((self
					    schemaPropertyNamed: 'browsers'
					    type: 'array'
					    description: 'The Pulsar browser windows and their open projects when operation=list.')
					   items: browserItemSchema;
					   yourself).
				  (self schemaPropertyNamed: 'operation' type: 'string' description: 'The operation that was performed.').
				  (self schemaPropertyNamed: 'browserIndex' type: 'integer' description: 'The browser window the operation targeted.').
				  (self
					   schemaPropertyNamed: 'name'
					   type: 'string'
					   description: 'The project name the operation targeted or the removed project name.').
				  (self schemaPropertyNamed: 'kind' type: 'string' description: 'The kind of the project: baseline or volatile.').
				  (self
					   schemaPropertyNamed: 'opened'
					   type: 'boolean'
					   description: 'Whether operation=open added the project to the browser tree.').
				  (self
					   schemaPropertyNamed: 'alreadyOpen'
					   type: 'boolean'
					   description: 'Whether the project was already open before operation=open.').
				  (self schemaPropertyNamed: 'closed' type: 'boolean' description: 'Whether operation=close removed the project.').
				  (self
					   schemaPropertyNamed: 'projectCount'
					   type: 'integer'
					   description: 'Number of projects open in the browser after the operation.').
				  ((self schemaPropertyNamed: 'projects' type: 'array' description: 'The projects open in the browser after the operation.')
					   items: projectItemSchema;
					   yourself) }
		  required: #(  )
]

{ #category : 'accessing' }
MCPPulsarProject >> defaultTitle [

	^ 'Pulsar Project'
]

{ #category : 'private - results' }
MCPPulsarProject >> errorNoBrowserAt: anIndex [
	"Answer an error result when there is no browser at anIndex."

	^ self errorResultText: 'No Pulsar browser at index ' , anIndex printString , '.' details: {
			  (#browserIndex -> anIndex).
			  (#browserCount -> self projectBrowsers size) } asDictionary
]

{ #category : 'private - results' }
MCPPulsarProject >> errorNoOpenProjectNamed: nameString inBrowser: aBrowser [
	"Answer an error result when the browser has no project matching nameString."

	| names |
	names := (self onUIThreadDo: [ aBrowser projectView openedProjects collect: [ :each | each name asString ] ]) asArray.
	^ self errorResultText: 'No open project named ' , nameString printString , '.' details: {
			  (#name -> nameString).
			  (#openProjects -> names) } asDictionary
]

{ #category : 'private - results' }
MCPPulsarProject >> errorUnknownBaselineNamed: nameString inBrowser: aBrowser [
	"Answer an error result with baseline suggestions when nameString matches no baseline."

	| query names suggestions |
	query := nameString asString trimBoth asLowercase.
	(query beginsWith: 'baselineof') ifTrue: [ query := query allButFirst: 10 ].
	names := (aBrowser projectView model allBaselines collect: [ :each | each name asString allButFirst: 10 ]) asArray.
	suggestions := (names select: [ :each | each asLowercase includesSubstring: query ]) asSortedCollection asArray.
	suggestions isEmpty ifTrue: [ suggestions := names asSortedCollection asArray ].
	suggestions size > 20 ifTrue: [ suggestions := suggestions copyFrom: 1 to: 20 ].
	^ self errorResultText: 'Unknown project ' , nameString printString , '.' details: {
			  (#name -> nameString).
			  (#suggestions -> suggestions) } asDictionary
]

{ #category : 'executing' }
MCPPulsarProject >> executeWithRequest: request [
	"Dispatch to list, open, or close based on the operation argument."

	| operation projectName browserIndex |
	operation := request stringArgumentNamed: 'operation'.
	operation ifNil: [ ^ self errorResultText: 'operation is required.' details: Dictionary new ].
	operation = 'list' ifTrue: [ ^ self listProjects ].
	(operation = 'open' or: [ operation = 'close' ]) ifFalse: [
		^ self errorResultText: 'Unknown operation: ' , operation details: { (#operation -> operation) } asDictionary ].
	projectName := request stringArgumentNamed: 'name'.
	projectName ifNil: [
		^ self errorResultText: 'name is required for ' , operation details: { (#operation -> operation) } asDictionary ].
	browserIndex := request nonNegativeIntegerArgumentNamed: 'browserIndex' default: 1.
	operation = 'open' ifTrue: [ ^ self openProjectNamed: projectName browserIndex: browserIndex ].
	^ self closeProjectNamed: projectName browserIndex: browserIndex
]

{ #category : 'private - results' }
MCPPulsarProject >> formattedDataContentBlocks: aDictionary [
	"Render the browser and project list as a text content block."

	| browsers lines |
	browsers := aDictionary at: #browsers ifAbsent: [ nil ].
	(browsers isNil or: [ browsers isEmpty ]) ifTrue: [ ^ #(  ) ].
	lines := OrderedCollection new.
	browsers do: [ :eachBrowser |
			lines add: '[' , (eachBrowser at: #browserIndex) printString , '] ' , (eachBrowser at: #title).
			(eachBrowser at: #projects) do: [ :eachProject |
					lines add: '  ' , (eachProject at: #index) printString , '. ' , (eachProject at: #name) , ' (' , (eachProject at: #kind)
						, ((eachProject at: #modified)
								 ifTrue: [ ', modified' ]
								 ifFalse: [ '' ]) , ')' ] ].
	^ { (self textContent: (lines joinUsing: String cr)) }
]

{ #category : 'operations' }
MCPPulsarProject >> listProjects [
	"Answer the browser windows and their open projects."

	| browsers browserInfos |
	browsers := self projectBrowsers.
	browserInfos := self onUIThreadDo: [
		                browsers collectWithIndex: [ :eachBrowser :eachIndex | self browserInfoFor: eachBrowser index: eachIndex ] ].
	^ self successResultText: browsers size printString , ' Pulsar browser(s) open.' data: {
			  (#operation -> 'list').
			  (#browsers -> browserInfos asArray) } asDictionary
]

{ #category : 'operations' }
MCPPulsarProject >> openProjectNamed: nameString browserIndex: anIndex [
	"Open the baseline project matching nameString in the browser at anIndex."

	| browser baseline alreadyOpen openedProject projectName kind projects |
	browser := self browserAt: anIndex.
	browser ifNil: [ ^ self errorNoBrowserAt: anIndex ].
	baseline := self baselineNamed: nameString inBrowser: browser.
	baseline ifNil: [ ^ self errorUnknownBaselineNamed: nameString inBrowser: browser ].
	alreadyOpen := self onUIThreadDo: [ browser projectView model projectNamed: nameString ].
	alreadyOpen ifNil: [ self onUIThreadDo: [ browser openProject: baseline ] ].
	openedProject := self onUIThreadDo: [ browser projectView model projectNamed: nameString ].
	projectName := openedProject ifNil: [ nameString asString ] ifNotNil: [ :project | project name asString ].
	kind := openedProject ifNil: [ 'baseline' ] ifNotNil: [ :project |
			        project isVolatileProject
				        ifTrue: [ 'volatile' ]
				        ifFalse: [ 'baseline' ] ].
	projects := self onUIThreadDo: [
			            browser projectView openedProjects collectWithIndex: [ :eachProject :eachIndex |
				            self projectInfoFor: eachProject index: eachIndex ] ].
	^ self
		  successResultText: (alreadyOpen
				   ifNil: [ 'Opened ' , projectName , ' in browser ' , anIndex printString , '.' ]
				   ifNotNil: [ projectName , ' was already open in browser ' , anIndex printString , '.' ])
		  data: {
				  (#operation -> 'open').
				  (#browserIndex -> anIndex).
				  (#name -> projectName).
				  (#kind -> kind).
				  (#opened -> alreadyOpen isNil).
				  (#alreadyOpen -> alreadyOpen notNil).
				  (#projectCount -> projects size).
				  (#projects -> projects asArray) } asDictionary
]

{ #category : 'private' }
MCPPulsarProject >> projectBrowsers [
	"Answer the open Pulsar browser windows that own a project tree, main browser first."

	^ self pulsarBrowsers select: [ :each | (each isKindOf: PulsarBrowser) and: [ each projectView notNil ] ]
]

{ #category : 'private' }
MCPPulsarProject >> projectInfoFor: aProject index: anIndex [
	"Answer a JSON-safe description of a project model."

	^ {
		  (#index -> anIndex).
		  (#name -> aProject name asString).
		  (#kind -> (aProject isVolatileProject
			    ifTrue: [ 'volatile' ]
			    ifFalse: [ 'baseline' ])).
		  (#modified -> aProject isManagedAndModified) } asDictionary
]
