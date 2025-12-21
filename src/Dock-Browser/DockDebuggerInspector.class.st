Class {
	#name : 'DockDebuggerInspector',
	#superclass : 'SpPresenter',
	#traits : 'DockTNotificationCenter + DockTPanelWindow + DockTSnapshot + DockTGlobalActionContainer + SpTModel',
	#classTraits : 'DockTNotificationCenter classTrait + DockTPanelWindow classTrait + DockTSnapshot classTrait + DockTGlobalActionContainer classTrait + SpTModel classTrait',
	#instVars : [
		'contextInspectorPresenter',
		'headerPresenter',
		'isForReceiver'
	],
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'defaults' }
DockDebuggerInspector class >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea bottom;
		yourself
]

{ #category : 'accessing - actions' }
DockDebuggerInspector class >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder 
		addGroup: #inspectorActions with: [ :group | group 
			addActionWith: [ :action | action 
				name: 'Inspect';
				description: 'Inspect current receiver';
				iconName: 'inspector';
				action: [ :aContext | aContext doInspectReceiver ] ];
			addActionWith: [ :action | action 
				name: 'Browse';
				description: 'Browse current receiver''s class';
				iconName: 'browser';
				action: [ :aContext | aContext doBrowseReceiverClass ] ] ]
]

{ #category : 'accessing' }
DockDebuggerInspector >> beForContext [

	isForReceiver := false
]

{ #category : 'accessing' }
DockDebuggerInspector >> beForReceiver [

	isForReceiver := true
]

{ #category : 'layout' }
DockDebuggerInspector >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: contextInspectorPresenter;
		yourself
]

{ #category : 'events' }
DockDebuggerInspector >> eventContextChanged: anAnnouncement [

	self inspectContextModel: anAnnouncement value
]

{ #category : 'events' }
DockDebuggerInspector >> eventModelSelected: anAnnouncement [
	
	self inspectContextModel: anAnnouncement value
]

{ #category : 'initialization' }
DockDebuggerInspector >> initialize [
	self beForContext.
	super initialize.
	self registerToEvents
]

{ #category : 'initialization' }
DockDebuggerInspector >> initializePresenters [

	headerPresenter := self instantiate: DockEditorToolbarPresenter.
	headerPresenter contentActions: (self globalActions actionsFor: #inspectorActions). 
	contextInspectorPresenter := self instantiate: StRawInspectionPresenter
]

{ #category : 'initialization' }
DockDebuggerInspector >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: (self model ifNotNil: [ :aModel | aModel fullName ] ifNil: [ '' ]);
		windowIcon: (self iconNamed: 'inspector');
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'private' }
DockDebuggerInspector >> inspectContextModel: aContextModel [

	contextInspectorPresenter model: (isForReceiver
		ifTrue: [ aContextModel entity receiver ]
		ifFalse: [ aContextModel entity ] ).
	self model: (DockInspectorModel on: aContextModel entity receiver)
]

{ #category : 'initialization' }
DockDebuggerInspector >> registerToDock: aDockBrowser [

	self notificationCenter: aDockBrowser notificationCenter
]

{ #category : 'initialization' }
DockDebuggerInspector >> registerToEvents [

	self announcer
		when: DockDebuggerContextChanged send: #eventContextChanged: to: self;
		when: DockModelSelected send: #eventModelSelected: to: self
]

{ #category : 'initialization' }
DockDebuggerInspector >> updatePresenter [
	| timeToRun |

	self model ifNil: [ ^ self ].

	timeToRun := [
		headerPresenter title: (isForReceiver
			ifTrue: [ 'Receiver' ]
			ifFalse: [ 'Context' ]).
		contextInspectorPresenter updatePresenter.
	] timeToRun.
	logger trace: timeToRun
]
