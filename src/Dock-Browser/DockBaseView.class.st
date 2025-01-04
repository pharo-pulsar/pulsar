Class {
	#name : 'DockBaseView',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PvTActionHolder',
	#classTraits : 'SpTModel classTrait + PvTActionHolder classTrait',
	#instVars : [
		'notificationCenter'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'defaults' }
DockBaseView class >> defaultDockPosition [

	^ DockPanelPosition new 
		area: DockArea center;
		yourself
]

{ #category : 'private' }
DockBaseView >> colorNamed: aString [

	^ self application colorNamed: aString
]

{ #category : 'accessing' }
DockBaseView >> dockPosition [

	^ self class defaultDockPosition
]

{ #category : 'scripting' }
DockBaseView >> newDockToolbar [

	^ self newToolbar
		addStyle: 'stToolbar';
		addStyle: 'dockToolbar';
		displayMode: self application toolbarDisplayMode;
		yourself
]

{ #category : 'scripting' }
DockBaseView >> newEntityTree [

	^ self newEasyTreeListView
		addStyle: 'stTree';
		display: [ :aModel | aModel name ];
		displayIcon: [ :aModel | aModel iconComposite buildOn: self application ];
		displayColor: [ :aModel | self colorNamed: aModel colorName ];
		children: [ :aModel | aModel children ];
		searchMatching: [ :anEntity :pattern | anEntity matches: pattern ];
		yourself
]

{ #category : 'private' }
DockBaseView >> notificationCenter [

	^ notificationCenter
]

{ #category : 'initialization' }
DockBaseView >> registerToDock: aDockBrowser [

	"take the announcer of the dock to broadcast what happens"
	notificationCenter := aDockBrowser announcer.
	self registerToEvents
]

{ #category : 'initialization' }
DockBaseView >> registerToEvents [
	"override this to subscribe to notifications"
]

{ #category : 'private - announcing' }
DockBaseView >> triggerActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (DockModelActivated newValue: anEntity realModel)
]

{ #category : 'private - announcing' }
DockBaseView >> triggerSelectEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (DockModelSelected newValue: anEntity realModel)
]
