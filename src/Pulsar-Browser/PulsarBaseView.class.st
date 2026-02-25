Class {
	#name : 'PulsarBaseView',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTActionContainer + PulsarTNotificationCenter + PulsarTSnapshot + PulsarTPanelWindowWithPlacedIcon + PulsarTPanelWindow',
	#classTraits : 'SpTModel classTrait + PulsarTActionContainer classTrait + PulsarTNotificationCenter classTrait + PulsarTSnapshot classTrait + PulsarTPanelWindowWithPlacedIcon classTrait + PulsarTPanelWindow classTrait',
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'defaults' }
PulsarBaseView class >> defaultPanelPosition [

	^ SpPanelPosition centerArea
]

{ #category : 'private' }
PulsarBaseView >> colorNamed: aString [

	^ self application colorNamed: aString
]

{ #category : 'initialization' }
PulsarBaseView >> initialize [

	super initialize.
	self registerToEvents.
	self registerToSystemEvents
]

{ #category : 'initialization' }
PulsarBaseView >> initializePanelWindow: aPanelwindowPresenter [

	super initializePanelWindow: aPanelwindowPresenter.
	aPanelwindowPresenter 
		whenPlacedDo: [ self panelPlaced: aPanelwindowPresenter ];
		whenTransferredDo: [ :ann | self panelTransferredFrom: ann fromWindow to: ann toWindow ]
]

{ #category : 'scripting' }
PulsarBaseView >> newEntityTree [

	^ self newEasyTreeListView
		addStyle: 'stTree';
		display: [ :aModel | aModel name ];
		displayIcon: [ :aModel | self iconNamed: aModel iconName ];
		displayColor: [ :aModel | self colorNamed: aModel colorName ];
		children: [ :aModel | aModel children ];
		searchMatching: [ :anEntity :pattern | anEntity matches: pattern ];
		yourself
]

{ #category : 'scripting' }
PulsarBaseView >> newPulsarToolbar [

	^ self newToolbar
		addStyle: 'stToolbar';
		addStyle: 'pulsarToolbar';
		displayMode: self application toolbarDisplayMode;
		yourself
]

{ #category : 'accessing' }
PulsarBaseView >> panelPosition [

	^ self class defaultPanelPosition
]

{ #category : 'private' }
PulsarBaseView >> panelTransferredFrom: fromWindow to: toWindow [ 

	self notificationCenter: toWindow announcer
]

{ #category : 'initialization' }
PulsarBaseView >> registerToBrowser: aPulsarBrowser [

	"take the announcer of the dock to broadcast what happens"
	self notificationCenter: aPulsarBrowser announcer
]

{ #category : 'initialization' }
PulsarBaseView >> registerToEvents [
	"override this to subscribe to notifications"
]

{ #category : 'initialization' }
PulsarBaseView >> registerToSystemEvents [
	"override to register to system events."
]

{ #category : 'private' }
PulsarBaseView >> scheduleJob: aBlock [
	"schedule a task that will show the working spinner while it executes"

	self withWindowDo: [ :aWindow | aWindow scheduleJob: aBlock ]
]

{ #category : 'private' }
PulsarBaseView >> scheduleTask: aBlock [
	"schedule a task that will be executed on background"

	self withWindowDo: [ :aWindow | aWindow scheduleTask: aBlock ]
]

{ #category : 'accessing' }
PulsarBaseView >> spotterTitle [
	
	self withPanelWindowDo: [ :aWindow | ^ aWindow title ].
	
	^ 'Unnamed'
]
