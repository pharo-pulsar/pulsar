Class {
	#name : 'PulsarBaseView',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTActionContainer + PulsarTNotificationCenter + PulsarTSnapshot + PulsarTPanelWindow',
	#classTraits : 'SpTModel classTrait + PulsarTActionContainer classTrait + PulsarTNotificationCenter classTrait + PulsarTSnapshot classTrait + PulsarTPanelWindow classTrait',
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

{ #category : 'events' }
PulsarBaseView >> eventThemeChanged: ann [

	self updatePresentersAfterThemeChange
]

{ #category : 'initialization' }
PulsarBaseView >> initialize [

	super initialize.
	self registerToEvents.
	self registerToSystemEvents
]

{ #category : 'initialization' }
PulsarBaseView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: (self model 
			ifNotNil: [ :aModel | aModel title ] 
			ifNil: [ 'NONAME' ]);
		whenClosedDo: [ self notifyEditorClosed ]
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

{ #category : 'initialization' }
PulsarBaseView >> registerToBrowser: aPulsarBrowser [
	
	logger trace: aPulsarBrowser.

	"take the announcer of the dock to broadcast what happens"
	self notificationCenter: aPulsarBrowser announcer.
]

{ #category : 'initialization' }
PulsarBaseView >> registerToEvents [
	"override this to subscribe to notifications"
	
	self announcer
		when: PulsarThemeChanged 
		send: #eventThemeChanged: 
		to: self
]

{ #category : 'initialization' }
PulsarBaseView >> registerToSystemEvents [
	"subclasses can fill this"
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
	
	self withPanelWidgetDo: [ :aPanelWindow | ^ aPanelWindow title ].
	
	^ 'Unnamed'
]

{ #category : 'theme' }
PulsarBaseView >> updatePresentersAfterSyntaxHighlightThemeChange [

	self traversePresentersDo: [ :each | each pulsarSyntaxHighlightThemeChanged ]
]

{ #category : 'theme' }
PulsarBaseView >> updatePresentersAfterThemeChange [

	self traversePresentersDo: [ :each | each pulsarThemeChanged ]
]
