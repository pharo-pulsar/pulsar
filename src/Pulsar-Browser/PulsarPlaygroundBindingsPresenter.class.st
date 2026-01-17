Class {
	#name : 'PulsarPlaygroundBindingsPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTActionContainer',
	#classTraits : 'SpTModel classTrait + PulsarTActionContainer classTrait',
	#instVars : [
		'bindingsListPresenter',
		'toolbarPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Playground',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'private' }
PulsarPlaygroundBindingsPresenter >> bindings [

	^ self model bindings associations 
		"this first, then sorted by name"
		sorted: ([ :each | each key beginsWith: #this ] descending), ([ :each | each key  ] ascending)
]

{ #category : 'initialization' }
PulsarPlaygroundBindingsPresenter >> connectPresenters [ 

	bindingsListPresenter announcer 
		when: PulsarBindingRemoved 
		send: #eventBindingRemoved: 
		to: self
]

{ #category : 'layout' }
PulsarPlaygroundBindingsPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: bindingsListPresenter;
		yourself
		
]

{ #category : 'private - definitions' }
PulsarPlaygroundBindingsPresenter >> defineActionsOn: aBuilder [
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
PulsarPlaygroundBindingsPresenter >> doRemoveAll [

	self model removeAllBindings.
	self updatePresenter.
	bindingsListPresenter takeKeyboardFocus
]

{ #category : 'private - actions' }
PulsarPlaygroundBindingsPresenter >> doRemoveBinding: aName [

	self model removeBindingNamed: aName.
	self updatePresenter.
	bindingsListPresenter takeKeyboardFocus
]

{ #category : 'events' }
PulsarPlaygroundBindingsPresenter >> eventBindingRemoved: ann [

	self doRemoveBinding:  ann value key
]

{ #category : 'initialization' }
PulsarPlaygroundBindingsPresenter >> initializePresenters [

	self
		addStyle: 'dockFlyingBrowser';
		addStyle: 'dockPlaygroundBindingsFlyingBrowser'.
		
	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
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
		rowPresenterClass: PulsarPlaygroundBindingRow;
		yourself
]

{ #category : 'initialization' }
PulsarPlaygroundBindingsPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	bindingsListPresenter items: self bindings
]
