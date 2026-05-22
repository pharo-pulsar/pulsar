"
A small component to add some ""updating control"" capabilities. 

You can protect your updating cycles by declaring a secting inside `updatingWhile:` and checking by `isUpdating`.

See my users for examples.
"
Trait {
	#name : 'PulsarTControlUpdate',
	#instVars : [
		'updating'
	],
	#category : 'Pulsar-Browser-Base',
	#package : 'Pulsar-Browser',
	#tag : 'Base'
}

{ #category : 'testing' }
PulsarTControlUpdate >> isUpdating [

	^ updating ifNil: [ updating := false ]
]

{ #category : 'private - updating' }
PulsarTControlUpdate >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := self isUpdating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]
