Class {
	#name : 'DockPlaygroundBindingsPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'bindingsListPresenter'
	],
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'layout' }
DockPlaygroundBindingsPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: bindingsListPresenter;
		yourself
		
]

{ #category : 'initialization' }
DockPlaygroundBindingsPresenter >> initializePresenters [

	self
		addStyle: 'dockFlyingBrowser';
		addStyle: 'dockPlaygroundBindingsFlyingBrowser'.

	bindingsListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'dockPlaygroundBindingList';
		rowPresenterClass: DockPlaygroundBindingRowPresenter;
		yourself
]

{ #category : 'initialization' }
DockPlaygroundBindingsPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	bindingsListPresenter items: self model bindings associations
]
