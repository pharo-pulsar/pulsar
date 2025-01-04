Class {
	#name : 'DockTranscript',
	#superclass : 'DockBaseView',
	#instVars : [
		'terminalPresenter',
		'service'
	],
	#category : 'Dock-Browser-Tool-Transcript',
	#package : 'Dock-Browser',
	#tag : 'Tool-Transcript'
}

{ #category : 'defaults' }
DockTranscript class >> defaultDockPosition [

	^ DockPanelPosition new 
		area: DockArea bottom;
		yourself
]

{ #category : 'defaults' }
DockTranscript class >> defaultTitle [

	^ 'Transcript'
]

{ #category : 'layout' }
DockTranscript >> defaultLayout [

	^ SpBoxLayout newVertical
		add: terminalPresenter;
		yourself
]

{ #category : 'private' }
DockTranscript >> ensureTranscriptService [
		
	service ifNotNil: [ ^ self ].
	
	service := TKTParameterizableService new.
	service name: 'DockTranscript service'.
	service stepDelay: 50 milliSeconds.
	service step: [ Transcript stepGlobal ]
]

{ #category : 'initialization' }
DockTranscript >> initializePresenters [

	self addStyle: 'stTranscript'.
	
	terminalPresenter := (self instantiate: VteTerminalPresenter)
		addStyle: 'stTerminal';
		withEditionContextMenu;
		withHyperlinks;
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
		
	Transcript addDependent: self

]

{ #category : 'private' }
DockTranscript >> unsubscribe [
	
	Transcript removeDependent: self
]

{ #category : 'updating' }
DockTranscript >> update: aSymbol [

	aSymbol = #appendEntry ifTrue: [ 
		terminalPresenter feed: Transcript contents withUnixLineEndings ]
	
]
