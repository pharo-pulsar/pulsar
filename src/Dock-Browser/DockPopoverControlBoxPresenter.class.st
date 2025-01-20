Class {
	#name : 'DockPopoverControlBoxPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

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
		fillWith: (SpActionGroup new
			addActionWith: [ :action | action 
				name: 'Dock';
				iconName: 'arrow-down';
				description: 'Dock this popover.';
				action: [ ] ];
			addActionWith: [ :action | action 
				name: 'Close';
				iconName: 'close';
				description: 'Close this popover.';
				action: [ self withPopoverDo: #dismiss ] ];
			yourself);
		yourself	
]
