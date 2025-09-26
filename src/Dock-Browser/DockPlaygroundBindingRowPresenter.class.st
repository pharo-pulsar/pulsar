Class {
	#name : 'DockPlaygroundBindingRowPresenter',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter',
		'valuePresenter',
		'removeActionPresenter'
	],
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'layout' }
DockPlaygroundBindingRowPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: namePresenter expand: false;
		add: valuePresenter;
		add: removeActionPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
DockPlaygroundBindingRowPresenter >> initializePresenters [

	namePresenter := self newLabel.
	valuePresenter := self newLabel 
		addStyle: 'dim';
		yourself.
	removeActionPresenter := self newButton
		addStyle: 'flat';
		icon: (self iconNamed: #delete);
		action: [];
		yourself
]

{ #category : 'initialization' }
DockPlaygroundBindingRowPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	namePresenter label: self model key asString.
	valuePresenter label: ' (', self model value asString, ')'
]
