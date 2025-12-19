Class {
	#name : 'DockPlaygroundInteractionModel',
	#superclass : 'StPlaygroundInteractionModel',
	#instVars : [
		'#readOnlyBindings => IndexedSlot',
		'#transientBindings => IndexedSlot'
	],
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'binding' }
DockPlaygroundInteractionModel >> bindingOf: aString [
	| key |

	key := aString asSymbol.
	(self transientBindings includesKey: key)
		ifTrue: [ ^ self transientBindings associationAt: key ].
	^ super bindingOf: key
]

{ #category : 'binding' }
DockPlaygroundInteractionModel >> bindings [
	| allBindings  |

	allBindings := self lastingBindings copy.
	
	self transientBindings associations 
		do: [ :each | allBindings add: each ].
		
	^ allBindings
]

{ #category : 'nil' }
DockPlaygroundInteractionModel >> createTransientBindings [

	^ Dictionary new
		add: (WorkspaceVariable key: #thisBrowser value: self owner window);
		yourself
]

{ #category : 'binding' }
DockPlaygroundInteractionModel >> hasBindingOf: aString [

	^ (self transientBindings includesKey: aString asSymbol)
		or: [ super hasBindingOf: aString ]
]

{ #category : 'binding' }
DockPlaygroundInteractionModel >> lastingBindings [ 

	^ super bindings
]

{ #category : 'accessing' }
DockPlaygroundInteractionModel >> removeAllBindings [

	super bindings removeAll
]

{ #category : 'binding' }
DockPlaygroundInteractionModel >> transientBindings [

	^ transientBindings ifNil: [ 
		transientBindings := self createTransientBindings ]
]
