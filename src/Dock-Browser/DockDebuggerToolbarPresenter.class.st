Class {
	#name : 'DockDebuggerToolbarPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'#toolbarActions',
		'#toolbarPresenter',
		'#debugger',
		'#lastOwner => WeakSlot'
	],
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'private' }
DockDebuggerToolbarPresenter >> announceContextChanged [

	self announceContextChangedUpdateTopContext: false
]

{ #category : 'private' }
DockDebuggerToolbarPresenter >> announceContextChangedUpdateTopContext: aBoolean [

	self 
		notifyContextChanged: self model 
		updateTopContext: aBoolean
]

{ #category : 'debug - testing' }
DockDebuggerToolbarPresenter >> canExecuteDebugCommand [

	^ self model
		ifNotNil: [ :aModel | aModel canExecuteDebugCommand ]
		ifNil: [ false ]
]

{ #category : 'debug - testing' }
DockDebuggerToolbarPresenter >> canExecuteRestartCommand [

	^ self model
		ifNotNil: [ :aModel | aModel canExecuteRestartCommand ]
		ifNil: [ false ]
]

{ #category : 'debug - testing' }
DockDebuggerToolbarPresenter >> canExecuteReturnCommand [

	^ self model
		ifNotNil: [ :aModel | aModel canExecuteReturnCommand ]
		ifNil: [ false ]
]

{ #category : 'accessing' }
DockDebuggerToolbarPresenter >> debugger [

	^ debugger ifNil: [ self owner ]
]

{ #category : 'accessing' }
DockDebuggerToolbarPresenter >> debugger: aDebuggerPresenter [

	debugger := aDebuggerPresenter
]

{ #category : 'layout' }
DockDebuggerToolbarPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		hAlignStart;
		vAlignStart;
		add: toolbarPresenter;
		yourself
]

{ #category : 'initialization' }
DockDebuggerToolbarPresenter >> initializePresenters [

	self addStyle: 'dockDebuggerToolbar'.

	toolbarPresenter := self newToolbar
		addStyle: 'stToolbar';
		addStyle: 'dockDebuggerActionsToolbar';
		displayMode: self application toolbarDisplayMode;
		fillWith: self toolbarActions
]

{ #category : 'accessing' }
DockDebuggerToolbarPresenter >> lastOwner [

	^ lastOwner
]

{ #category : 'accessing' }
DockDebuggerToolbarPresenter >> lastOwner: aPresenter [

	lastOwner := aPresenter
]

{ #category : 'private' }
DockDebuggerToolbarPresenter >> notificationCenter [

	^ self debugger notificationCenter
]

{ #category : 'private - announcing' }
DockDebuggerToolbarPresenter >> notifyContextChanged: aContextModel updateTopContext: aBoolean [ 

	aContextModel ifNil: [ ^ self ].
	self notificationCenter announce: (DockDebuggerContextChanged new
		value: aContextModel;
		updateTopContext: aBoolean;
		yourself)
]

{ #category : 'debug - actions' }
DockDebuggerToolbarPresenter >> proceedDebugSession [ 

	self model proceedDebugSession.
	self withWindowDo: [ :aWindow | aWindow close ]
]

{ #category : 'debug - actions' }
DockDebuggerToolbarPresenter >> restartCurrentContext [

	self model restartCurrentContext.
	self announceContextChanged
]

{ #category : 'debug - actions' }
DockDebuggerToolbarPresenter >> returnEnteredValue [
	| expression |
	expression := self application newRequest
		title: 'Enter expression for return value:';
		openModal.
	expression ifNil: [ ^ self ].
	
	self model returnValueFromExpression: expression.
	self announceContextChanged
]

{ #category : 'debug - actions' }
DockDebuggerToolbarPresenter >> runToSelection [
 
	"self model 
		runToSelection: contextEditor selectionInterval
		inContext: stackView selectedContextModel.
	self announceContextChanged"
]

{ #category : 'debug - actions' }
DockDebuggerToolbarPresenter >> stepInto [

	logger trace.
	self model stepInto.
	logger trace: self model entity.
	logger trace: self model session interruptedContext.
	self announceContextChangedUpdateTopContext: true
]

{ #category : 'debug - actions' }
DockDebuggerToolbarPresenter >> stepOver [

	self model stepOver.
	self announceContextChangedUpdateTopContext: true
]

{ #category : 'debug - actions' }
DockDebuggerToolbarPresenter >> stepThrough [

	self model stepThrough.
	self announceContextChangedUpdateTopContext: true
]

{ #category : 'initialization' }
DockDebuggerToolbarPresenter >> toolbarActions [

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
DockDebuggerToolbarPresenter >> updatePresenter [

	self toolbarActions allCommands 
		do: [ :each | each updateEnableStatus ]
]
