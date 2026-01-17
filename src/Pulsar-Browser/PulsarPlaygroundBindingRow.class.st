Class {
	#name : 'PulsarPlaygroundBindingRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter',
		'valuePresenter',
		'removeActionPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Playground',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'private' }
PulsarPlaygroundBindingRow >> announceRemove [

	self listView announce: (PulsarBindingRemoved newValue: self model)
]

{ #category : 'layout' }
PulsarPlaygroundBindingRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: namePresenter expand: false;
		add: valuePresenter;
		add: removeActionPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
PulsarPlaygroundBindingRow >> initializePresenters [

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

{ #category : 'testing' }
PulsarPlaygroundBindingRow >> isReadOnly: aBinding [

	self flag: #TODO. "Hardcoded, this needs to be taken from a list elsewere (same that uses PulsarPlayground)" 
	^ aBinding key asSymbol = #thisBrowser.
]

{ #category : 'initialization' }
PulsarPlaygroundBindingRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	namePresenter label: self model key asString.
	valuePresenter label: ' (', self model value asString, ')'.
	
	removeActionPresenter visible: (self isReadOnly: self model) not
]
