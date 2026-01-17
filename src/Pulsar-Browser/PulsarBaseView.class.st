Class {
	#name : 'PulsarBaseView',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTActionContainer + PulsarTNotificationCenter + PulsarTSnapshot',
	#classTraits : 'SpTModel classTrait + PulsarTActionContainer classTrait + PulsarTNotificationCenter classTrait + PulsarTSnapshot classTrait',
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
PulsarBaseView >> initializePanelWindow: aPanelwindowPresenter [

	super initializePanelWindow: aPanelwindowPresenter.
	aPanelwindowPresenter whenTransferredDo: [ :ann | 
		self 
			panelTransferredFrom: ann fromWindow 
			to: ann toWindow ]
]

{ #category : 'scripting' }
PulsarBaseView >> newEntityTree [

	^ self newEasyTreeListView
		addStyle: 'stTree';
		display: [ :aModel | aModel name ];
		displayIcon: [ :aModel | aModel iconComposite buildOn: self application ];
		displayColor: [ :aModel | self colorNamed: aModel colorName ];
		children: [ :aModel | aModel children ];
		searchMatching: [ :anEntity :pattern | anEntity matches: pattern ];
		yourself
]

{ #category : 'scripting' }
PulsarBaseView >> newPulsarToolbar [

	^ self newToolbar
		addStyle: 'stToolbar';
		addStyle: 'dockToolbar';
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
	self notificationCenter: aPulsarBrowser announcer.
	self registerToEvents
]

{ #category : 'initialization' }
PulsarBaseView >> registerToEvents [
	"override this to subscribe to notifications"
]

{ #category : 'private' }
PulsarBaseView >> scheduleJob: aBlock [
	"schedule a task that will show the working spinner while it executes"

	self application scheduleTask: [
		self withWindowDo: #jobStart.
		aBlock ensure: [ 
			self withWindowDo: #jobEnd ] ]
]

{ #category : 'accessing' }
PulsarBaseView >> spotterTitle [
	
	self withPanelWindowDo: [ :aWindow | ^ aWindow title ].
	
	^ 'Unnamed'
]
