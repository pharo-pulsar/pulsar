Class {
	#name : 'DockPlaygroundBindingsPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + DockTActionContainer',
	#classTraits : 'SpTModel classTrait + DockTActionContainer classTrait',
	#instVars : [
		'bindingsListPresenter',
		'toolbarPresenter'
	],
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'private' }
DockPlaygroundBindingsPresenter >> bindings [

	^ self model bindings associations 
		"this first, then sorted by name"
		sorted: ([ :each | each key beginsWith: #this ] descending), ([ :each | each key  ] ascending)
]

{ #category : 'initialization' }
DockPlaygroundBindingsPresenter >> connectPresenters [ 

	bindingsListPresenter announcer 
		when: DockBindingRemoved 
		send: #eventBindingRemoved: 
		to: self
]

{ #category : 'layout' }
DockPlaygroundBindingsPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: bindingsListPresenter;
		yourself
		
]

{ #category : 'private - definitions' }
DockPlaygroundBindingsPresenter >> defineActionsOn: aBuilder [
	<dockActions>
	
	^ aBuilder addGroup: #actions with: [ :group | group
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'Remove All';
			iconName: 'delete';
			description: 'Remove all bindings';
			action: [ self doRemoveAll ] ] ]
]

{ #category : 'private - actions' }
DockPlaygroundBindingsPresenter >> doRemoveAll [

	self model removeAllBindings.
	self updatePresenter.
	bindingsListPresenter takeKeyboardFocus
]

{ #category : 'private - actions' }
DockPlaygroundBindingsPresenter >> doRemoveBinding: aName [

	self model removeBindingNamed: aName.
	self updatePresenter.
	bindingsListPresenter takeKeyboardFocus
]

{ #category : 'events' }
DockPlaygroundBindingsPresenter >> eventBindingRemoved: ann [

	self doRemoveBinding:  ann value key
]

{ #category : 'initialization' }
DockPlaygroundBindingsPresenter >> initializePresenters [

	self
		addStyle: 'dockFlyingBrowser';
		addStyle: 'dockPlaygroundBindingsFlyingBrowser'.
		
	toolbarPresenter := self instantiate: DockToolbarPresenter.
	toolbarPresenter actions: self actions.
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
		yourself
]

{ #category : 'initialization' }
DockPlaygroundBindingsPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	bindingsListPresenter items: self bindings
]
