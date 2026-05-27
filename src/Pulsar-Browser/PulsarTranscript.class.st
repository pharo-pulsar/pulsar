Class {
	#name : 'PulsarTranscript',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTSnapshot + PulsarTTaskWorker',
	#classTraits : 'PulsarTSnapshot classTrait + PulsarTTaskWorker classTrait',
	#instVars : [
		'terminalPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Transcript',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Transcript'
}

{ #category : 'defaults' }
PulsarTranscript class >> defaultPanelPosition [

	^ SpPanelPosition bottomArea
]

{ #category : 'defaults' }
PulsarTranscript class >> defaultTitle [

	^ 'Transcript'
]

{ #category : 'layout' }
PulsarTranscript >> defaultLayout [

	^ SpBoxLayout newVertical
		add: terminalPresenter;
		yourself
]

{ #category : 'private - definitions' }
PulsarTranscript >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #transcript with: [ :group | group 
		addActionWith: [ :action | action
			name: 'Clear';
			description: 'Clear transcript';
			action: [ :aContext | aContext doClearTranscript ] ] ]
]

{ #category : 'private - actions' }
PulsarTranscript >> doClearTranscript [
	
	terminalPresenter clear
]

{ #category : 'initialization' }
PulsarTranscript >> initialize [

	super initialize
]

{ #category : 'initialization' }
PulsarTranscript >> initializePresenters [

	self addStyle: 'stTranscript'.
	
	terminalPresenter := (self instantiate: VteTerminalPresenter)
		addStyle: 'stTerminal';
		withEditionContextMenu;
		withHyperlinks;
		actions: (self actions actionsFor: #transcript);
		yourself
]

{ #category : 'initialization' }
PulsarTranscript >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: (self iconNamed: 'transcript');
		whenClosedDo: [ self windowClosed ]
]

{ #category : 'updating' }
PulsarTranscript >> update: aSymbol [

	aSymbol = #appendEntry ifTrue: [ 
		self queueTask: [ 
			terminalPresenter feed: Transcript contents withUnixLineEndings ] ]
]

{ #category : 'private' }
PulsarTranscript >> windowClosed [

	self purgeTaskWorker
]
