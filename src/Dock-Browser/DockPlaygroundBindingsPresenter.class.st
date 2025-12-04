Class {
	#name : 'DockPlaygroundBindingsPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'bindingsListPresenter',
		'toolbarPresenter'
	],
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'layout' }
DockPlaygroundBindingsPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: bindingsListPresenter;
		yourself
		
]

{ #category : 'events' }
DockPlaygroundBindingsPresenter >> eventBindingRemoved: ann [

	self model removeBindingNamed: ann value key.
	self updatePresenter.
	bindingsListPresenter takeKeyboardFocus
]

{ #category : 'initialization' }
DockPlaygroundBindingsPresenter >> initializePresenters [

	self
		addStyle: 'dockFlyingBrowser';
		addStyle: 'dockPlaygroundBindingsFlyingBrowser'.
		
	toolbarPresenter := self instantiate: DockToolbarPresenter.
	toolbarPresenter addPresenter: (self newButton 
		addStyle: 'flat';
		icon: (self iconNamed: 'close');
		help: 'Dismiss';
		action: [ self withPopoverDo: #dismiss ];
		yourself).

	bindingsListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'dockPlaygroundBindingList';
		rowPresenterClass: DockPlaygroundBindingRowPresenter;
		yourself.
		
	bindingsListPresenter announcer 
		when: DockBindingRemoved 
		send: #eventBindingRemoved: 
		to: self
]

{ #category : 'initialization' }
DockPlaygroundBindingsPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	bindingsListPresenter items: self model bindings associations
]
