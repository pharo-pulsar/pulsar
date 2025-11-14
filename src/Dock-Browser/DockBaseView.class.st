Class {
	#name : 'DockBaseView',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + DockTActionHolder + DockTNotificationCenter + DockTSnapshot',
	#classTraits : 'SpTModel classTrait + DockTActionHolder classTrait + DockTNotificationCenter classTrait + DockTSnapshot classTrait',
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'defaults' }
DockBaseView class >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea center;
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

{ #category : 'initialization' }
DockBaseView >> registerToDock: aDockBrowser [

	"take the announcer of the dock to broadcast what happens"
	self notificationCenter: aDockBrowser announcer.
	self registerToEvents
]

{ #category : 'initialization' }
DockBaseView >> registerToEvents [
	"override this to subscribe to notifications"
]

{ #category : 'accessing' }
DockBaseView >> spotterTitle [
	
	self withPanelWindowDo: [ :aWindow | ^ aWindow title ].
	
	^ 'Unnamed'
]
