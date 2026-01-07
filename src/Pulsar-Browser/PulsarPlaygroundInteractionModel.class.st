Class {
	#name : 'PulsarPlaygroundInteractionModel',
	#superclass : 'StPlaygroundInteractionModel',
	#instVars : [
		'#readOnlyBindings => IndexedSlot',
		'#transientBindings => IndexedSlot'
	],
	#category : 'Pulsar-Browser-Tool-Playground',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'binding' }
PulsarPlaygroundInteractionModel >> bindingOf: aString [
	| key |

	key := aString asSymbol.
	(self transientBindings includesKey: key)
		ifTrue: [ ^ self transientBindings associationAt: key ].
	^ super bindingOf: key
]

{ #category : 'binding' }
PulsarPlaygroundInteractionModel >> bindings [
	| allBindings  |

	allBindings := self lastingBindings copy.
	
	self transientBindings associations 
		do: [ :each | allBindings add: each ].
		
	^ allBindings
]

{ #category : 'nil' }
PulsarPlaygroundInteractionModel >> createTransientBindings [

	^ Dictionary new
		add: (WorkspaceVariable key: #thisBrowser value: self owner window);
		yourself
]

{ #category : 'binding' }
PulsarPlaygroundInteractionModel >> hasBindingOf: aString [

	^ (self transientBindings includesKey: aString asSymbol)
		or: [ super hasBindingOf: aString ]
]

{ #category : 'binding' }
PulsarPlaygroundInteractionModel >> lastingBindings [ 

	^ super bindings
]

{ #category : 'accessing' }
PulsarPlaygroundInteractionModel >> removeAllBindings [

	super bindings removeAll
]

{ #category : 'accessing' }
PulsarPlaygroundInteractionModel >> removeBindingNamed: aName [

	super bindings removeKey: aName asSymbol
]

{ #category : 'binding' }
PulsarPlaygroundInteractionModel >> transientBindings [

	^ transientBindings ifNil: [ 
		transientBindings := self createTransientBindings ]
]
