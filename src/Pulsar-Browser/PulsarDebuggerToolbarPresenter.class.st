Class {
	#name : 'PulsarDebuggerToolbarPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'#toolbarActions',
		'#toolbarPresenter',
		'#debugger',
		'#lastOwner => WeakSlot'
	],
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'private' }
PulsarDebuggerToolbarPresenter >> announceContextChanged [

	self announceContextChangedUpdateTopContext: false
]

{ #category : 'private' }
PulsarDebuggerToolbarPresenter >> announceContextChangedUpdateTopContext: aBoolean [

	self 
		notifyContextChanged: self model 
		updateTopContext: aBoolean
]

{ #category : 'debug - testing' }
PulsarDebuggerToolbarPresenter >> canExecuteDebugCommand [

	^ self model
		ifNotNil: [ :aModel | aModel canExecuteDebugCommand ]
		ifNil: [ false ]
]

{ #category : 'debug - testing' }
PulsarDebuggerToolbarPresenter >> canExecuteRestartCommand [

	^ self model
		ifNotNil: [ :aModel | aModel canExecuteRestartCommand ]
		ifNil: [ false ]
]

{ #category : 'debug - testing' }
PulsarDebuggerToolbarPresenter >> canExecuteReturnCommand [

	^ self model
		ifNotNil: [ :aModel | aModel canExecuteReturnCommand ]
		ifNil: [ false ]
]

{ #category : 'accessing' }
PulsarDebuggerToolbarPresenter >> debugger [

	^ debugger ifNil: [ self owner ]
]

{ #category : 'accessing' }
PulsarDebuggerToolbarPresenter >> debugger: aDebuggerPresenter [

	debugger := aDebuggerPresenter
]

{ #category : 'layout' }
PulsarDebuggerToolbarPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		hAlignStart;
		vAlignStart;
		add: toolbarPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarDebuggerToolbarPresenter >> initializePresenters [

	self addStyle: 'dockDebuggerToolbar'.

	toolbarPresenter := self newToolbar
		addStyle: 'stToolbar';
		addStyle: 'dockDebuggerActionsToolbar';
		displayMode: self application toolbarDisplayMode;
		fillWith: self toolbarActions
]

{ #category : 'accessing' }
PulsarDebuggerToolbarPresenter >> lastOwner [

	^ lastOwner
]

{ #category : 'accessing' }
PulsarDebuggerToolbarPresenter >> lastOwner: aPresenter [

	lastOwner := aPresenter
]

{ #category : 'private' }
PulsarDebuggerToolbarPresenter >> notificationCenter [

	^ self debugger notificationCenter
]

{ #category : 'private - announcing' }
PulsarDebuggerToolbarPresenter >> notifyContextChanged: aContextModel updateTopContext: aBoolean [ 

	aContextModel ifNil: [ ^ self ].
	self notificationCenter announce: (PulsarDebuggerContextChanged new
		value: aContextModel;
		updateTopContext: aBoolean;
		yourself)
]

{ #category : 'debug - actions' }
PulsarDebuggerToolbarPresenter >> proceedDebugSession [ 

	self model proceedDebugSession.
	self withWindowDo: [ :aWindow | aWindow close ]
]

{ #category : 'debug - actions' }
PulsarDebuggerToolbarPresenter >> restartCurrentContext [

	self model restartCurrentContext.
	self announceContextChanged
]

{ #category : 'debug - actions' }
PulsarDebuggerToolbarPresenter >> returnEnteredValue [
	| expression |
	expression := self application newRequest
		title: 'Enter expression for return value:';
		openModal.
	expression ifNil: [ ^ self ].
	
	self model returnValueFromExpression: expression.
	self announceContextChanged
]

{ #category : 'debug - actions' }
PulsarDebuggerToolbarPresenter >> runToSelection [
 
	"self model 
		runToSelection: contextEditor selectionInterval
		inContext: stackView selectedContextModel.
	self announceContextChanged"
]

{ #category : 'debug - actions' }
PulsarDebuggerToolbarPresenter >> stepInto [

	logger trace.
	self model stepInto.
	logger trace: self model entity.
	logger trace: self model session interruptedContext.
	self announceContextChangedUpdateTopContext: true
]

{ #category : 'debug - actions' }
PulsarDebuggerToolbarPresenter >> stepOver [

	self model stepOver.
	self announceContextChangedUpdateTopContext: true
]

{ #category : 'debug - actions' }
PulsarDebuggerToolbarPresenter >> stepThrough [

	self model stepThrough.
	self announceContextChangedUpdateTopContext: true
]

{ #category : 'initialization' }
PulsarDebuggerToolbarPresenter >> toolbarActions [

	^ toolbarActions ifNil: [ 
		toolbarActions := SpActionGroup new
			add: (StProceedCommand forSpecContext: self);
			add: (StStepIntoCommand forSpecContext: self);
			add: (StStepOverCommand forSpecContext: self);
			add: (StStepThroughCommand forSpecContext: self);
			add: (StRunToSelectionCommand forSpecContext: self);
			add: (StRestartCommand forSpecContext: self);
			add: (StReturnValueCommand forSpecContext: self);
			yourself ]
]

{ #category : 'initialization' }
PulsarDebuggerToolbarPresenter >> updatePresenter [

	self toolbarActions allCommands 
		do: [ :each | each updateEnableStatus ]
]
