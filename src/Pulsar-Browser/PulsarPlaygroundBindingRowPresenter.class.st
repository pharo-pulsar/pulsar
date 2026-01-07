Class {
	#name : 'PulsarPlaygroundBindingRowPresenter',
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
PulsarPlaygroundBindingRowPresenter >> announceRemove [

	self listView announce: (PulsarBindingRemoved newValue: self model)
]

{ #category : 'layout' }
PulsarPlaygroundBindingRowPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: namePresenter expand: false;
		add: valuePresenter;
		add: removeActionPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
PulsarPlaygroundBindingRowPresenter >> initializePresenters [

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
PulsarPlaygroundBindingRowPresenter >> isReadOnly: aBinding [

	self flag: #TODO. "Hardcoded, this needs to be taken from a list elsewere (same that uses PulsarPlayground)" 
	^ aBinding key asSymbol = #thisBrowser.
]

{ #category : 'initialization' }
PulsarPlaygroundBindingRowPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	namePresenter label: self model key asString.
	valuePresenter label: ' (', self model value asString, ')'.
	
	removeActionPresenter visible: (self isReadOnly: self model) not
]
