Class {
	#name : 'PulsarPopoverControlBoxPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbarPresenter',
		'detachAction',
		'attachAction'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'private' }
PulsarPopoverControlBoxPresenter >> announceAttach [ 

	attachAction ifNil: [ ^ self ].
	attachAction value
]

{ #category : 'private' }
PulsarPopoverControlBoxPresenter >> announceDettach [ 

	detachAction ifNil: [ ^ self ].
	detachAction value
]

{ #category : 'layout' }
PulsarPopoverControlBoxPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: toolbarPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarPopoverControlBoxPresenter >> initializePresenters [

	(toolbarPresenter := self newToolbar)
		addStyle: 'stToolbar';
		addStyle: 'pulsarToolbar';
		addStyle: 'pulsarPopoverControlToolbar';
		displayMode: self application toolbarDisplayMode;
		fillWith: self popoverControlGroup
]

{ #category : 'events' }
PulsarPopoverControlBoxPresenter >> onAttach: aBlock [

	attachAction := aBlock
]

{ #category : 'events' }
PulsarPopoverControlBoxPresenter >> onDetach: aBlock [

	detachAction := aBlock
]

{ #category : 'accessing' }
PulsarPopoverControlBoxPresenter >> popoverActions: anActionGroup [

	toolbarPresenter fillWith: (SpActionGroup new
		add: anActionGroup;
		add: self popoverControlGroup;
		yourself)
]

{ #category : 'initialization' }
PulsarPopoverControlBoxPresenter >> popoverControlGroup [

	^ SpActionGroup new
		addActionWith: [ :action | action 
			name: 'Attach';
			iconName: 'arrowDown';
			description: 'Attach popover.';
			action: [ self announceAttach ] ];
		addActionWith: [ :action | action 
			name: 'Detach';
			iconName: 'arrowUp';
			description: 'Detach popover.';
			action: [ self announceDettach ] ];
		addActionWith: [ :action | action 
			name: 'Close';
			iconName: 'close';
			description: 'Close popover.';
			action: [ self withPopoverDo: #dismiss ] ];
		yourself
]
