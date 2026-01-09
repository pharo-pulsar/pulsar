Class {
	#name : 'PulsarDebuggerInspector',
	#superclass : 'SpPresenter',
	#traits : 'PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTSnapshot + PulsarTGlobalActionContainer + SpTModel',
	#classTraits : 'PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTSnapshot classTrait + PulsarTGlobalActionContainer classTrait + SpTModel classTrait',
	#instVars : [
		'contextInspectorPresenter',
		'headerPresenter',
		'isForReceiver'
	],
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'defaults' }
PulsarDebuggerInspector class >> defaultPanelPosition [

	^ SpPanelPosition bottomArea
]

{ #category : 'accessing - actions' }
PulsarDebuggerInspector class >> defineActionsOn: aBuilder [
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
PulsarDebuggerInspector >> beForContext [

	isForReceiver := false
]

{ #category : 'accessing' }
PulsarDebuggerInspector >> beForReceiver [

	isForReceiver := true
]

{ #category : 'layout' }
PulsarDebuggerInspector >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: contextInspectorPresenter;
		yourself
]

{ #category : 'events' }
PulsarDebuggerInspector >> eventContextChanged: anAnnouncement [

	self inspectContextModel: anAnnouncement value
]

{ #category : 'events' }
PulsarDebuggerInspector >> eventModelSelected: anAnnouncement [
	
	self inspectContextModel: anAnnouncement value
]

{ #category : 'initialization' }
PulsarDebuggerInspector >> initialize [

	self beForContext.
	super initialize.
	self registerToEvents
]

{ #category : 'initialization' }
PulsarDebuggerInspector >> initializePresenters [

	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	headerPresenter contentActions: (self globalActions actionsFor: #inspectorActions). 
	contextInspectorPresenter := self instantiate: StRawInspectionPresenter
]

{ #category : 'initialization' }
PulsarDebuggerInspector >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: (self model ifNotNil: [ :aModel | aModel fullName ] ifNil: [ '' ]);
		windowIcon: (self iconNamed: 'inspector');
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'private' }
PulsarDebuggerInspector >> inspectContextModel: aContextModel [

	contextInspectorPresenter model: (isForReceiver
		ifTrue: [ aContextModel entity receiver ]
		ifFalse: [ aContextModel entity ] ).
	self model: (PulsarInspectorModel on: aContextModel entity receiver)
]

{ #category : 'initialization' }
PulsarDebuggerInspector >> registerToEvents [

	self announcer
		when: PulsarDebuggerContextChanged send: #eventContextChanged: to: self;
		when: PulsarModelSelected send: #eventModelSelected: to: self
]

{ #category : 'initialization' }
PulsarDebuggerInspector >> registerToPulsar: aPulsarBrowser [

	self notificationCenter: aPulsarBrowser notificationCenter
]

{ #category : 'initialization' }
PulsarDebuggerInspector >> updatePresenter [
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
