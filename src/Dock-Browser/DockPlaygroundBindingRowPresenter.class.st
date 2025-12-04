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

{ #category : 'private' }
DockPlaygroundBindingRowPresenter >> announceRemove [

	self listView announce: (DockBindingRemoved newValue: self model)
]

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
		action: [ self announceRemove ];
		yourself
]

{ #category : 'as yet unclassified' }
DockPlaygroundBindingRowPresenter >> isReadOnly: aBinding [

	self flag: #TODO. "Hardcoded, this needs to be taken from a list elsewere (same that uses DockPlayground)" 
	^ aBinding key asSymbol = #thisBrowser.
]

{ #category : 'initialization' }
DockPlaygroundBindingRowPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	namePresenter label: self model key asString.
	valuePresenter label: ' (', self model value asString, ')'.
	
	removeActionPresenter visible: (self isReadOnly: self model) not
]
