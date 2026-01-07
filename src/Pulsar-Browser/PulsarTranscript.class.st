Class {
	#name : 'PulsarTranscript',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTSnapshot',
	#classTraits : 'PulsarTSnapshot classTrait',
	#instVars : [
		'terminalPresenter',
		'runner'
	],
	#category : 'Pulsar-Browser-Tool-Transcript',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Transcript'
}

{ #category : 'defaults' }
PulsarTranscript class >> defaultPulsarPosition [

	^ SpPanelPosition new 
		area: SpPanelArea bottom;
		yourself
]

{ #category : 'defaults' }
PulsarTranscript class >> defaultTitle [

	^ 'Transcript'
]

{ #category : 'accessing - actions' }
PulsarTranscript class >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #transcript with: [ :group | group 
		addActionWith: [ :action | action
			name: 'Clear';
			description: 'Clear transcript';
			action: [ :aContext | aContext doClearTranscript ] ] ]
]

{ #category : 'layout' }
PulsarTranscript >> defaultLayout [

	^ SpBoxLayout newVertical
		add: terminalPresenter;
		yourself
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
		whenOpenedDo: [ self subscribe ];
		whenClosedDo: [ self unsubscribe ]
]

{ #category : 'private' }
PulsarTranscript >> subscribe [
		
	runner := PulsarWorker new 
		inTool: self class;
		start	

]

{ #category : 'private' }
PulsarTranscript >> unsubscribe [
	
	runner stop
]

{ #category : 'updating' }
PulsarTranscript >> update: aSymbol [

	aSymbol = #appendEntry ifTrue: [ 
		runner schedule: [ 
			terminalPresenter feed: Transcript contents withUnixLineEndings ] ]
]
