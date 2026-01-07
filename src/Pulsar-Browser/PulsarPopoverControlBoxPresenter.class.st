Class {
	#name : 'PulsarPopoverControlBoxPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbarPresenter',
		'dockAction'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'private' }
PulsarPopoverControlBoxPresenter >> announcePulsar [ 

	dockAction ifNil: [ ^ self ].
	dockAction value
]

{ #category : 'layout' }
PulsarPopoverControlBoxPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: toolbarPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarPopoverControlBoxPresenter >> initializePresenters [

	toolbarPresenter := self newToolbar
		addStyle: 'stToolbar';
		addStyle: 'dockToolbar';
		addStyle: 'dockPopoverControlToolbar';
		displayMode: self application toolbarDisplayMode;
		fillWith: self popoverControlGroup;
		yourself	
]

{ #category : 'events' }
PulsarPopoverControlBoxPresenter >> onPulsar: aBlock [

	dockAction := aBlock
]

{ #category : 'api - actions' }
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
			name: 'Pulsar';
			iconName: 'arrow-down';
			description: 'Pulsar popover.';
			action: [ self announcePulsar ] ];
		addActionWith: [ :action | action 
			name: 'Close';
			iconName: 'close';
			description: 'Close popover.';
			action: [ self withPopoverDo: #dismiss ] ];
		yourself
]
