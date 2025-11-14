Class {
	#name : 'DockTranscript',
	#superclass : 'DockBaseView',
	#traits : 'DockTSnapshot',
	#classTraits : 'DockTSnapshot classTrait',
	#instVars : [
		'terminalPresenter',
		'runner'
	],
	#category : 'Dock-Browser-Tool-Transcript',
	#package : 'Dock-Browser',
	#tag : 'Tool-Transcript'
}

{ #category : 'defaults' }
DockTranscript class >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea bottom;
		yourself
]

{ #category : 'defaults' }
DockTranscript class >> defaultTitle [

	^ 'Transcript'
]

{ #category : 'accessing - actions' }
DockTranscript class >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #transcript with: [ :aGroup | aGroup 
		addActionWith: [ :anAction | anAction
			name: 'Clear';
			description: 'Clear transcript';
			action: [ :aContext | aContext doClearTranscript ] ] ]
]

{ #category : 'layout' }
DockTranscript >> defaultLayout [

	^ SpBoxLayout newVertical
		add: terminalPresenter;
		yourself
]

{ #category : 'private - actions' }
DockTranscript >> doClearTranscript [
	
	terminalPresenter clear
]

{ #category : 'initialization' }
DockTranscript >> initialize [

	super initialize
]

{ #category : 'initialization' }
DockTranscript >> initializePresenters [

	self addStyle: 'stTranscript'.
	
	terminalPresenter := (self instantiate: VteTerminalPresenter)
		addStyle: 'stTerminal';
		withEditionContextMenu;
		withHyperlinks;
		actions: (self actions actionsFor: #transcript);
		yourself
]

{ #category : 'initialization' }
DockTranscript >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: (self iconNamed: 'transcript');
		whenOpenedDo: [ self subscribe ];
		whenClosedDo: [ self unsubscribe ]
]

{ #category : 'private' }
DockTranscript >> subscribe [
		
	runner := DockWorker new 
		inTool: self class;
		start	

]

{ #category : 'private' }
DockTranscript >> unsubscribe [
	
	runner stop
]

{ #category : 'updating' }
DockTranscript >> update: aSymbol [

	aSymbol = #appendEntry ifTrue: [ 
		runner schedule: [ 
			terminalPresenter feed: Transcript contents withUnixLineEndings ] ]
]
