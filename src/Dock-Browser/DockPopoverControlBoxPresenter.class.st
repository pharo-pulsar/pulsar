Class {
	#name : 'DockPopoverControlBoxPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbarPresenter',
		'dockAction'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'private' }
DockPopoverControlBoxPresenter >> announceDock [ 

	dockAction ifNil: [ ^ self ].
	dockAction value
]

{ #category : 'layout' }
DockPopoverControlBoxPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: toolbarPresenter;
		yourself
]

{ #category : 'initialization' }
DockPopoverControlBoxPresenter >> initializePresenters [

	toolbarPresenter := self newToolbar
		addStyle: 'stToolbar';
		addStyle: 'dockToolbar';
		addStyle: 'dockPopoverControlToolbar';
		displayMode: self application toolbarDisplayMode;
		fillWith: self popoverControlGroup;
		yourself	
]

{ #category : 'events' }
DockPopoverControlBoxPresenter >> onDock: aBlock [

	dockAction := aBlock
]

{ #category : 'api - actions' }
DockPopoverControlBoxPresenter >> popoverActions: anActionGroup [

	toolbarPresenter fillWith: (SpActionGroup new
		add: anActionGroup;
		add: self popoverControlGroup;
		yourself)
]

{ #category : 'initialization' }
DockPopoverControlBoxPresenter >> popoverControlGroup [

	^ SpActionGroup new
		addActionWith: [ :action | action 
			name: 'Dock';
			iconName: 'arrow-down';
			description: 'Dock popover.';
			action: [ self announceDock ] ];
		addActionWith: [ :action | action 
			name: 'Close';
			iconName: 'close';
			description: 'Close popover.';
			action: [ self withPopoverDo: #dismiss ] ];
		yourself
]
