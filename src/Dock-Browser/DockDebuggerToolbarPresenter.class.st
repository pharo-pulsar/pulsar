Class {
	#name : 'DockDebuggerToolbarPresenter',
	#superclass : 'SpPresenter',
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

{ #category : 'initialization' }
DockDebuggerToolbarPresenter >> toolbarActions [

	^ toolbarActions ifNil: [ 
		toolbarActions := SpActionGroup new
			add: (StProceedCommand forSpecContext: self debugger);
			add: (StStepIntoCommand forSpecContext: self debugger);
			add: (StStepOverCommand forSpecContext: self debugger);
			add: (StStepThroughCommand forSpecContext: self debugger);
			add: (StRunToSelectionCommand forSpecContext: self debugger);
			add: (StRestartCommand forSpecContext: self debugger);
			add: (StReturnValueCommand forSpecContext: self debugger);
			yourself ]
]

{ #category : 'initialization' }
DockDebuggerToolbarPresenter >> updatePresenter [

	self toolbarActions allCommands 
		do: [ :each | each updateEnableStatus ]
]
